class GenericScraperJob < ActiveJob::Base
  queue_as :scrapers

  def perform(scraper_reg_rec, db_rec)
    # db_record is the database adaptor class; it should respond to :uri and :save_payload!
    # scraper_rec holds the page extraction rules in a JSON format
    if db_rec.respond_to?(:original_uri) and db_rec.respond_to?(:save_payload!)
      begin
        s = Scrapers::GenericScraper.new db_rec.original_uri, scraper_reg_rec.scraper_json
        payload = s.create_payload
      rescue Scrapers::DomFailure
        status = 'scraper failed'
      rescue SocketError, URI::InvalidURIError, Errno::ETIMEDOUT => e
        status = "OpenURI failed with #{e.message}"
      else
        # For now, scrapers will not do any post processing. Eventually, we need to find a home for this
        s.post_process_payload if s.respond_to? :post_process_payload

        if s.has_links?
          schedule_spider_jobs s
        end
        
        db_rec.save_payload!(s.payload_data)
      end
    else
      status = 'Bad argument passed to job'
    end
  end

  private
  def schedule_spider_jobs(scraper_obj)
    scraper_obj.crawl_links.each do |link_list_name, list_metadata|
      # For now we just care about the forward links, we aren't doing anything interesting
      # With all the remaining metadata we are gathering

      regis_name = list_metadata['scraper_registration_name']
      scraper_reg_reg = ScraperRegistration.find_by_scraper_registration_name regis_name
      
      if scraper_reg_reg
        # If such a scraper was registered, use it; else fail silently
        list_metadata['links'].each do |hyperlink_pair|
          SpiderManager::Agent.enqueue_request scraper_reg_reg, hyperlink_pair[0]
        end
      end
    end
  end
end

