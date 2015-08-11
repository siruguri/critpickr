require 'test_helper'

class RtMovieScraperTest < ActiveSupport::TestCase
  def setup
    WebMock.disable_net_connect!(allow_localhost: true)
    stub_request(:get, 'http://www.rottentomatoes.com/m/moviename').to_return(
      status: 200, body: fixture_file('rt-movie-response.html'))
  end

  test 'RT scraper works' do
    r=Scrapers::GenericScraper.new(scraper_adaptors(:rt_me_moviename).original_uri,
                                   scraper_registrations(:rt_me_reg).scraper_json)

    r.create_payload

    assert_not_nil r.payload_data['movie_name']
    assert_equal 12, r.payload_data['critic_data'].size
    assert_equal 1, r.payload_data['allcrits_tomato_score'].size

    kevin_carr = r.payload_data['critic_data'].select { |h| h['name'] == ["Kevin Carr"]}
    assert_match /4.5 /, kevin_carr[0]['rating'][0]

    assert r.has_links?
    assert_equal 6, r.crawl_links.first[1]['links'].size
  end
end
