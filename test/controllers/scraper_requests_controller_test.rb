require 'test_helper'

class ScraperRequestsControllerTest < ActionController::TestCase
  include ActiveJob::TestHelper

  test 'request creation' do
    s_reg = scraper_registrations(:reg_1)
    
    @params = {scraper_request: {uri: 'testuri', scraper_registration: s_reg.id}}
    init_movie_entries = (s_reg.db_model.constantize).count
    
    assert_enqueued_with(job: GenericScraperJob) do
      post :create, @params
    end

    assert_match /RtMovieEntry/, enqueued_jobs[0][:args][1]['_aj_globalid']
    assert_equal init_movie_entries + 1, (s_reg.db_model.constantize).count

    assert_redirected_to scraper_requests_path

    # Can do this idempotently
    assert_no_difference("#{s_reg.db_model}.count") do
      post :create, @params
    end
  end

  test 'index' do
    get :index
    assert_template :index
    assert_select('li', ScraperRequest.count)
  end

  test 'new' do
    get :new
    assert assigns(:scraper_request)

    assert_select('option', ScraperRegistration.count + 1) do |elts|
      assert_match /RtMovieEntry/, elts[4].text
    end
  end
end
