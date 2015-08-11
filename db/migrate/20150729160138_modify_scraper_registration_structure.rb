class ModifyScraperRegistrationStructure < ActiveRecord::Migration
  def change
    remove_column :scraper_registrations, :scraper_class, :string
    add_column :scraper_registrations, :scraper_json, :text
  end
end
