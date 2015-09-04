require 'test_helper'

class ScraperEmailTest < ActionMailer::TestCase
  include ActiveJob::TestHelper

  test 'mail works' do
    StatusMailer.scraper_email('a message').deliver_now
    assert_not ActionMailer::Base.deliveries.empty?
    email = ActionMailer::Base.deliveries.last
    assert_match /message/i, email.body.raw_source
    assert_equal 1, email.to.size
  end
end


    
  
