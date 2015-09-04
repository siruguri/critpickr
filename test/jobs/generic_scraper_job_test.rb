require 'test_helper'

class GenericScraperJobTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
  
  def setup
    @initial_job_record_count = JobRecord.count
  end
                              
  test 'handles dom failures' do
    Scrapers::GenericScraper.any_instance.stubs(:create_payload).raises Scrapers::DomFailure.new('failed_patt')
    GenericScraperJob.perform_now scraper_requests(:rt_me_req), ScraperAdaptor.create
    @expected_status = /fail/i
  end
  
  test 'handles socket failure' do
    Scrapers::GenericScraper.any_instance.stubs(:create_payload).raises SocketError
    GenericScraperJob.perform_now scraper_requests(:rt_me_req), ScraperAdaptor.create
    @expected_status = /fail/i
  end
  
  describe 'successful execution' do
    before do
      @test_payload_array = [1, 2, 3]
      @test_links_array = [['uri', 'anchor text'],
                           ['uri', 'anchor text'],
                           ['uri', 'anchor text']]
      
      Scrapers::GenericScraper.any_instance.stubs(:create_payload).with.returns true
      # The dummy db record will look for the key 'key'
      Scrapers::GenericScraper.any_instance.stubs(:payload_data).returns({'key' => @test_payload_array})
      Scrapers::GenericScraper.any_instance.
        stubs(:crawl_links).
        returns({name1: {'scraper_registration_name' => 'RtPersonPage', 'links' => @test_links_array}})
    end

    it 'works without spidering' do
      Scrapers::GenericScraper.any_instance.stubs(:has_links?).with.returns false

      d = ScraperAdaptor.create

      assert_enqueued_with(job: ActionMailer::DeliveryJob) do
        GenericScraperJob.perform_now scraper_requests(:rt_me_req), d
      end

      assert_equal @test_payload_array.to_json, d.payload['key'].gsub(/\s/, '')
      @expected_status = /success/i
    end

    it 'works with spidering' do
      Scrapers::GenericScraper.any_instance.stubs(:has_links?).with.returns true
      GenericScraperJob.perform_now scraper_requests(:rt_me_req), ScraperAdaptor.create

      # Account for the ActiveMailer job
      assert_equal 1 + @test_links_array.size, enqueued_jobs.size
      @expected_status = /success/i
    end
  end
end
