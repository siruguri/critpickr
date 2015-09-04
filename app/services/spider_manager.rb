module SpiderManager
  class SpiderException < Exception
  end

  class Agent
    def self.enqueue_request(scraper_reg, uri, options = {})
      # scraper_reg: a scraper registration that has the JSON formatted scraping rules
      # uri: URI to scrape

      if uri.nil? || scraper_reg.nil? || !(scraper_reg.is_a? ScraperRegistration)
        raise SpiderException, "No such URI or registration"
      end
      
      begin
        m = scraper_reg.db_model || 'ScraperAdaptor'
        db_target = m.constantize
        # For reasons I don't entirely understand, we have to call new on the ActiveRecord class
        # Before it's column-methods are in the class' instance methods.
        db_target.new
        if !(db_target.ancestors[0].instance_methods.include?(:original_uri))
          raise SpiderException, "no original URI method in db class"
        end
      rescue NameError => e
        if /uninitialized constant/.match e.message
          e.message = "uninitialized constants in: (#{scraper_reg.db_model})"
        end
        raise e
      end

      s = ScraperRequest.find_or_initialize_by(uri: uri, scraper_registration: scraper_reg)
      if s.new_record? or options[:rerun] != 'false'
        dbrec = db_target.find_or_create_by(original_uri: uri)
        s.status = 'started'
        s.save
        
        GenericScraperJob.perform_later s, dbrec
      end

      s
    end
  end
end
