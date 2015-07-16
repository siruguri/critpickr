class AddIndexOnCriticAndMovieToRtCriticRating < ActiveRecord::Migration
  def change
    add_index :rt_critic_ratings, [:rt_movie_entry_id, :rt_critic_id], unique: true
  end
end
