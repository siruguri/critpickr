require 'test_helper'

class RtMovieScraperTest < ActiveSupport::TestCase
  def setup
    stub_request(:get, 'http://www.rottentomatoes.com/m/moviename').to_return(
      status: 200, body: fixture_file('rt-response.html'))
  end

  test 'RT scraper works' do
    r=Scrapers::RtMovieScraper.new('http://www.rottentomatoes.com/m/moviename')

    r.create_payload; r.post_process_payload

    assert_not_nil r.payload_data[:movie_name]

    assert_equal 12, r.payload_data[:critic_data].size
    kevin_carr = r.payload_data[:critic_data].select { |h| h[:name] == ["Kevin Carr"]}
    assert_match /4.5 /, kevin_carr[0][:rating][0]
    assert_equal 2, r.payload_data[:ratings].size
  end
end
