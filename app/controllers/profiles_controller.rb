class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def movie_sort_list
    @movie_data = MovieSortOrderEntry.where(user: current_user).order(:sort_position).map do |m|
      {id: m.movie_id, name: m.movie.movie_name}
    end.to_json
  end
  
  def set_sort
    movie_name = params[:commit]
    MovieManager::Sorter.add_to_sort_list current_user, movie_name

    @ordering = MovieSortOrderEntry.where user: current_user
    render :movie_sort_list
  end
end
