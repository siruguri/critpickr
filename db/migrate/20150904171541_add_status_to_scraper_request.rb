class AddStatusToScraperRequest < ActiveRecord::Migration
  def change
    add_column :scraper_requests, :status, :string
  end
end
