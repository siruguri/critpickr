class CreateRtCriticRatings < ActiveRecord::Migration
  def change
    create_table :rt_critic_ratings do |t|
      t.float :original_score
      t.integer :original_score_base
      t.integer :rt_movie_entry_id
      t.string :tomato
      t.integer :rt_critic_id
    end
  end
end
