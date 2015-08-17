class MoviesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    if params[:q] and params[:q].strip.length > 0
      unless (@movie_list = Movie.search(params[:q]))
        t=TmdbApiWrapper::Client.new(api_key: ENV['TMDB_API_KEY'])
        @movie_list = Movie.add_from_tmdb!(t.search_movie query: params[:q].strip)
      end

      # movie_list is nil if the add to DB method failed
      if @movie_list
        @movie_list_partial = true
      end
    end
    render :new
  end

  def new
  end
end
