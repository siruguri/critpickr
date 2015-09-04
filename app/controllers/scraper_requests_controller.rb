class ScraperRequestsController < ApplicationController
  before_action :check_params, only: [:create]
  
  def new
    @scraper_request = ScraperRequest.new
  end

  def create
    reg = ScraperRegistration.where(id: params[:scraper_request][:scraper_registration_id].to_i)[0]
    begin
      SpiderManager::Agent.enqueue_request reg, params[:scraper_request][:uri]
    rescue SpiderManager::SpiderException, NameError => e
      flash[:alert] = "Spidering failed to initialize: #{e.message}"
    else
      flash[:notice] = 'Created request!'
    end

    if flash[:alert]
      @scraper_request = ScraperRequest.new(params[:scraper_request].permit(:uri, :scraper_registration_id))    
      render :new
    else
      redirect_to scraper_requests_path
    end
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
