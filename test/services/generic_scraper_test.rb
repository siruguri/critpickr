require 'test_helper'

class GenericScraperTest < ActiveSupport::TestCase
  def setup
    stub_request(:get, 'http://www.google.com').to_return(
      status: 200, body: fixture_file('google-response.html'))
      
    @new_scraper = Scrapers::GenericScraper.new('http://www.google.com', "{\"data\": [{\"pattern\" : \"a\", \"value\": 1}],\"links\":[]}")
  end

  test 'Basic inheritance works' do
    # Assert that a default payload is created (when the <title> element is there)
    payload = @new_scraper.create_payload
    assert_equal 'Google', payload[:data_root][:title]
  end

  test 'blank links does not cause problems' do
    @blank_scraper = Scrapers::GenericScraper.new('http://www.google.com',
                                                  {'data' => [{'name' => 'a', 'pattern' => 'title'}]}.to_json)
    assert_nothing_raised do
      payload = @blank_scraper.create_payload
    end
  end

  test 'badly written rules do not cause failures' do
    @bad_scraper = Scrapers::GenericScraper.new('http://www.google.com',
                                                {'data' => [1,2,3]}.to_json)
    assert_nothing_raised do
      payload = @bad_scraper.create_payload
    end
  end
end
