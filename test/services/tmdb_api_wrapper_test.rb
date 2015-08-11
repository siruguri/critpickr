require 'test_helper'

class TmdbApiWrapperTest < ActiveSupport::TestCase
  def setup
    set_net_stubs
  end
  
  test 'wrapper works' do
    resp = TmdbApiWrapper::Client.new(api_key: Rails.application.secrets.tmdb_api_key).search_movie(query: 'chitty')
    assert_equal 'Chitty Chitty Bang Bang', resp['results'][0]['title']
  end
end
