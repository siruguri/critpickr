class AddScraperRegistrationNameToScraperRegistrations < ActiveRecord::Migration
  def change
    add_column :scraper_registrations, :scraper_registration_name, :string
  end
end
