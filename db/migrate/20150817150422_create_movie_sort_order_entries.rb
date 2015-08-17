class CreateMovieSortOrderEntries < ActiveRecord::Migration
  def change
    create_table :movie_sort_order_entries do |t|
      t.integer :movie_id
      t.integer :sort_position
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
