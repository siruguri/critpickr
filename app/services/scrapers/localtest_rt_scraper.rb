require 'nokogiri'

require_relative './safe_dom'
require_relative './generic_scraper'
require_relative './rt_movie_scraper'
r = Scrapers::RtMovieScraper.new 'http://www.rottentomatoes.com/m/sound_of_music/'
puts r.payload.inspect
