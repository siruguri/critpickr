module SpiderManager
  class SpiderException < Exception
  end

  class Agent
    def self.enqueue_request(scraper_reg, uri)
      # scraper_reg: a scraper registration that has the JSON formatted scraping rules
      # uri: URI to scrape
      
      begin
        db_target = scraper_reg.db_model.constantize
        # For reasons I don't entirely understand, we have to call new on the ActiveRecord class
        # Before it's column-methods are in the class' instance methods.
        db_target.new
      rescue NameError => e
        if /uninitialized constant/.match e.message
          e.message = "uninitialized constants in: (#{scraper_reg.db_model})"
        end
        raise e
      end
      
      if db_target.ancestors[0].instance_methods.include?(:original_uri)
        dbrec = db_target.find_or_create_by(original_uri: uri)
        GenericScraperJob.perform_later scraper_reg, dbrec
      else
        raise SpiderException, "no original URI method in db class"
      end
    end
  end
end
