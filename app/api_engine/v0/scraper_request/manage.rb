module V0
  module ScraperRequest
    class Manage < Grape::API
      resource :scraper_request do
        post :create do
          status_code = 401
          status_message = 'registration not found'
          
          reg = ScraperRegistration.where(id: params[:scraper_registration].to_i)
          if reg.count > 0
            reg = reg[0]
            
            # Keep a record in the database that we are scraping something so we can avoid running the same scrape twice
            # Might want to eventually have a forced re-crawl option
            s = ::ScraperRequest.find_or_initialize_by(uri: params[:uri], scraper_registration: reg)
            if !s.persisted?
              # WIP: It's possible here for the request to make it to the database, but not
              # trigger the spider manager. That's a bug.
              s.save
              begin
                SpiderManager::Agent.enqueue_request reg, s.uri
              rescue SpiderManager::SpiderException, NameError => e
                status_message = "Spidering failed to initialize: #{e.message}"
              else
                status_code = 200
                status_message = 'request created'
              end
            else
              status_code = 200
              status_message = "previously scheduled to ID #{s.id}"
            end
          end

          status status_code
          h = {message: status_message}
          if status_code == 200
            h.merge!({request_id: s.id})
          end

          h
        end
      end
    end
  end
end

