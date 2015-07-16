class AddMovieNameToRtMovieEntry < ActiveRecord::Migration
  def change
    add_column :rt_movie_entries, :movie_name, :string
  end
end
