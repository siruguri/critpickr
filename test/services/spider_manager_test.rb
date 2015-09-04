require 'test_helper'

class SpiderManagerTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
  
  test 'raises name error exception correctly' do
    assert_raises(NameError) do
      SpiderManager::Agent.enqueue_request(scraper_registrations(:bad_db_model_name_reg), 'http://www.a.com')
    end
  end

  test 'raises spidermanager exception correctly' do
    assert_raises(SpiderManager::SpiderException) do
      SpiderManager::Agent.enqueue_request(scraper_registrations(:db_model_wo_uri_reg), 'http://www.a.com')
    end
  end

  test 'lack of db model in registration defaults to scraper_adaptor' do
    init_db_entries = ScraperAdaptor.count
    
    assert_enqueued_with(job: GenericScraperJob) do
      SpiderManager::Agent.enqueue_request(scraper_registrations(:no_db_model_reg), 'http://www.a.com')
    end

    assert_match /ScraperAdaptor/, enqueued_jobs[0][:args][1]['_aj_globalid']
    assert_equal init_db_entries + 1, ScraperAdaptor.count
  end
end
