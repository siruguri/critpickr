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
        # WIP: It's possible here for the request to make it to the database, but not
        # trigger the spider manager. That's a bug.
        s.save
      end
      begin
        SpiderManager::Agent.enqueue_request reg, s.uri
      rescue SpiderException, NameError => e
        flash[:alert] = "Spidering failed to initialize: #{e.message}"
      else
        flash[:notice] = 'Created request!'
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
