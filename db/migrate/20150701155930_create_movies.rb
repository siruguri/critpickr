class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :original_uri
      t.string :movie_name
      t.string :ratings

      t.timestamps
    end
  end
end
