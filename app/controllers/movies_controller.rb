class MoviesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    if params[:q] and params[:q].strip.length > 0
      t=TmdbApiWrapper::Client.new(api_key: ENV['TMDB_API_KEY'])

      @movie_info = t.search_movie query: params[:q].strip
      @movie_list_partial = true
    end
    render :new
  end

  def new
  end
end
