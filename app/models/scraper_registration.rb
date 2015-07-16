class ScraperRegistration < ActiveRecord::Base
  def scraper_name
    "#{scraper_class} + #{db_model}"
  end
end
