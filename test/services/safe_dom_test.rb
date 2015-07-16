require 'test_helper'

class RedditScraperTest < ActiveSupport::TestCase
  def setup
    @html_string = fixture_file('html_string.txt')
  end
  
  describe '#try_xpath' do
    it 'works' do
      s = Scrapers::SafeDom.new(Nokogiri::HTML(@html_string))
      assert_equal 'id result', s.try_xpath('//div[@id="try_id"]').text
    end

    it 'doesnt work' do
      t = Scrapers::SafeDom.new(Nokogiri::HTML(@html_string))

      err = assert_raise Scrapers::DomFailure do
        t.try_xpath('//div[@id="try_no_id"]').text
      end

      assert_match /div..id..try/, err.message
    end    
  end
end

