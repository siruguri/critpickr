class AddIndexOnCriticAndMovieToMovieCriticRating < ActiveRecord::Migration
  def change
    add_index :movie_critic_ratings, [:movie_id, :movie_critic_id], unique: true
  end
end
