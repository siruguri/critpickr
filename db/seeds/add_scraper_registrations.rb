s = ScraperRegistration.find_or_create_by(db_model: 'RtMovieEntry') do |newrec|
  newrec.scraper_class='Scrapers::RtMovieScraper'
  newrec.save
end

s = ScraperRegistration.find_or_create_by(db_model: 'ScraperAdaptor') do |newrec|
  newrec.scraper_class='Scrapers::WikipediaScraper'
  newrec.save
end

