require 'test_helper'

class APITest < APITestCase
  test 'GET /broken-link' do
    get '/broken-link'
    assert_equal 404, last_response.status
    assert_equal JSON.parse(last_response.body)['id'], 'not_found'
  end

  test 'GET /raises-error' do
    assert_nothing_raised(StandardError) { get '/raises-error' }
    assert_equal 500, last_response.status
    assert_equal JSON.parse(last_response.body)['id'], 'internal_error'
  end

  test 'All routes authenticated by default' do
    get '/authenticated'
    assert 401, last_response.status
    assert_equal 'unauthenticated', JSON.parse(last_response.body)['id']
  end
end
