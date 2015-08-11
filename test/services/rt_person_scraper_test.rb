require 'test_helper'

class RtPersonScraperTest < ActiveSupport::TestCase
  def setup
    stub_request(:get, 'http://www.rottentomatoes.com/m/personname').to_return(
      status: 200, body: fixture_file('rt-person-response.html'))
  end

  test 'RT scraper works' do
    r=Scrapers::GenericScraper.new scraper_adaptors(:rt_me_personname).original_uri,
                                   scraper_registrations(:rt_person_reg).scraper_json
    r.create_payload
    assert_not_nil r.payload_data['all_bio']
    assert_equal 5, r.payload_data['all_bio'].size
  end
end
