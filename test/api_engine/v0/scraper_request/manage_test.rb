require 'test_helper'

class V0::ScraperRequest::ManageTest < APITestCase
  include ActiveJob::TestHelper

  def post_request(reg, uri, options={})
    if options
      k = '&' + options.map { |k, v| "#{k}=#{v}"}.join('&')
    else
      k = ''
    end
    
    post "/scraper_request/create?scraper_registration=#{reg}&uri=#{uri}#{k}"
  end
  
  describe 'POST /scraper_request/create' do
    describe 'authenticated' do
      describe 'with valid params' do
        before do
          _, @user = authenticate users(:valid)
        end

        it 'creates a scraper job' do
          assert_enqueued_with(job: GenericScraperJob) do
            post_request scraper_registrations(:reg_1).id, 'http://www.google.com'
          end
          assert_equal 200, last_response.status
        end

        it 'cannot make requests twice' do
          old_req = scraper_requests(:old_req)
          assert_no_difference('ScraperRequest.count') do
            post_request old_req.scraper_registration.id, old_req.uri, rerun: false
          end

          assert_equal 200, last_response.status
          j=JSON.parse(last_response.body)
          assert_match /previously/, j['message']
        end

        it 'will not allow bad parameters' do
          post_request(1000, 'auri.com')
          assert_equal 422, last_response.status
        end
      end
    end
  end
end

