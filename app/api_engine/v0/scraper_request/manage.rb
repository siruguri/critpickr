module V0
  module ScraperRequest
    class Manage < Grape::API
      resource :scraper_request do
        post :create do
          status_code = 422

          reg = ScraperRegistration.where(id: params[:scraper_registration].to_i)[0]
          begin
            s = SpiderManager::Agent.enqueue_request reg, params[:uri], rerun: params[:rerun]
          rescue SpiderManager::SpiderException, NameError => e
            status_message = "Spidering failed to initialize: #{e.message}"
          else
            status_code = 200
            status_message = s.status == 'started' ? 'request created' : 'previously requested'
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

