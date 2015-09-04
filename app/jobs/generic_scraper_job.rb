class GenericScraperJob < ActiveJob::Base
  queue_as :scrapers

  def perform(scraper_req, db_rec)
    # db_rec is the database adaptor class; it should respond to :uri and :save_payload!
    # scraper_req holds the registration, which has page extraction rules in a JSON format, and URI
    
    scraper_req.status = ''
    if db_rec.respond_to?(:original_uri) and db_rec.respond_to?(:save_payload!)
      scraper_req.status = "PROCESS: #{db_rec.original_uri} - "
      begin
        s = Scrapers::GenericScraper.new db_rec.original_uri, scraper_req.scraper_registration.scraper_json
        payload = s.create_payload
      rescue Scrapers::DomFailure
        scraper_req.status += '-> scraper failed'
      rescue SocketError, URI::InvalidURIError, Errno::ETIMEDOUT, Errno::ECONNREFUSED => e
        scraper_req.status += "-> openuri failed with #{e.message}"
      else
        # For now, scrapers will not do any post processing. Eventually, we need to find a home for this
        s.post_process_payload if s.respond_to? :post_process_payload

        if s.has_links?
          schedule_spider_jobs s
        end
        
        db_rec.save_payload!(s.payload_data)
        scraper_req.status += "-> success"
      end
    else
      scraper_req.status += '-> Bad arguments passed to job'
    end

    scraper_req.save
    StatusMailer.scraper_email(scraper_req.status).deliver_later

    scraper_req
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

