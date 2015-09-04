require 'test_helper'

class ScraperRequestsControllerTest < ActionController::TestCase
  include ActiveJob::TestHelper

  describe 'request creation' do
    it "works when everything works" do
      s_reg = scraper_registrations(:reg_1)
      
      @params = {scraper_request: {uri: 'testuri', scraper_registration_id: s_reg.id}}
      init_movie_entries = (s_reg.db_model.constantize).count
      
      assert_enqueued_with(job: GenericScraperJob) do
        post :create, @params
      end

      post :create, @params
      assert_equal 2, enqueued_jobs.size

      assert_match /Movie/, enqueued_jobs[0][:args][1]['_aj_globalid']
      assert_equal init_movie_entries + 1, (s_reg.db_model.constantize).count

      assert_redirected_to scraper_requests_path
    end

    it "works when the scraper registration is weird" do
      s_reg = scraper_registrations :db_model_wo_uri_reg
      @params = {scraper_request: {uri: 'testuri', scraper_registration_id: s_reg.id}}
      post :create, @params
      assert_template :new
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
      assert (elts.select { |j| /Movie/.match(j.text) }).size > 0
    end
  end
end
