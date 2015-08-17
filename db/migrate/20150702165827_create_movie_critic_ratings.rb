class CreateMovieCriticRatings < ActiveRecord::Migration
  def change
    create_table :movie_critic_ratings do |t|
      t.float :original_score
      t.integer :original_score_base
      t.integer :movie_id
      t.string :tomato
      t.integer :movie_critic_id
    end
  end
end
