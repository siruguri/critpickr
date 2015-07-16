class CreateScraperAdaptors < ActiveRecord::Migration
  def change
    create_table :scraper_adaptors do |t|
      t.string :structure_type
      t.hstore :payload
      t.string :original_uri
    end
  end
end
