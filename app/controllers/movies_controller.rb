class MoviesController < ApplicationController
  def create
    if params[:q] and params[:q].strip.length > 0
      t=TmdbApiWrapper::Client.new(api_key: ENV['TMDB_API_KEY'])

      @movie_info = t.search_movie query: params[:q].strip
      render :movie_list
    else
      render :new
    end
  end

  def new
  end
end
