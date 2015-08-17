class CreateMovieCritic < ActiveRecord::Migration
  def change
    create_table :movie_critics do |t|
      t.string :name
    end
  end
end
