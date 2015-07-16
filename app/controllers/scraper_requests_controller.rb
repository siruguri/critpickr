class ScraperRequestsController < ApplicationController
  before_action :check_params, only: [:create]
  
  def new
    @scraper_request = ScraperRequest.new
  end

  def create
    reg = ScraperRegistration.find params[:scraper_request][:scraper_registration].to_i
    if reg
      s = ScraperRequest.create(uri: params[:scraper_request][:uri], scraper_registration: reg)

      db_target = (reg.db_model.constantize)
      db_target.new
      if db_target.ancestors[0].instance_methods.include?(:original_uri)
        dbrec = db_target.find_or_create_by(original_uri: s.uri)
        (reg.scraper_class.constantize).new.scrape_later dbrec
        flash[:notice] = 'Created request!'
      else
        flash[:alert] = 'Target DB model lacks original_uri method!'
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
