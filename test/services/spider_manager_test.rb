require 'test_helper'

class SpiderManagerTest < ActiveSupport::TestCase
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
end
