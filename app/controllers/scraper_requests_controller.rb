class ScraperRequestsController < ApplicationController
  before_action :check_params, only: [:create]
  
  def new
    @scraper_request = ScraperRequest.new
  end

  def create
    reg = ScraperRegistration.find params[:scraper_request][:scraper_registration].to_i
    if reg
      # Keep a record in the database that we are scraping something so we can avoid running the same scrape twice
      # Might want to eventually have a forced re-crawl option
      s = ScraperRequest.find_or_initialize_by(uri: params[:scraper_request][:uri], scraper_registration: reg)

      if !s.persisted?
        s.save
        begin
          SpiderManager::Agent.enqueue_request reg, s.uri
        rescue SpiderError => e
          flash[:alert] = 'Target DB model lacks original_uri method!'
        else
          flash[:notice] = 'Created request!'
        end
      end
    end
    redirect_to scraper_requests_path
  end

  def index
    @scraper_requests = ScraperRequest.all
  end

  private
  def check_params
    unless params[:scraper_request]
      redirect_to scraper_requests_path
      false
    end
    true
  end
end
