class CreateRtCritic < ActiveRecord::Migration
  def change
    create_table :rt_critics do |t|
      t.string :name
    end
  end
end
