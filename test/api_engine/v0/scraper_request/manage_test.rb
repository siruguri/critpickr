require 'test_helper'

class V0::ScraperRequest::ManageTest < APITestCase
  include ActiveJob::TestHelper
  
  describe 'POST /scraper_request/create' do
    describe 'authenticated' do
      describe 'with valid params' do
        before do
          _, @user = authenticate users(:valid)
        end

        it 'creates a scraper job' do
          assert_enqueued_with(job: GenericScraperJob) do
            post "/scraper_request/create?scraper_registration=#{scraper_registrations(:reg_1).id}&uri=http://www.google.com"
          end
          assert_equal 200, last_response.status
        end
      end
    end
  end
end

