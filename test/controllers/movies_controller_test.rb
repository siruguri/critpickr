require 'test_helper'

class MoviesControllerTest < ActionController::TestCase
  def setup
    set_net_stubs
  end
  
  test 'routes exist' do
    assert_routing({path: '/movie', method: :post}, {controller: 'movies', action: 'create'})
  end

  test 'post works without entry' do
    post :create, {q: ' '}
    assert_template :new

    post :create, {q: 'chitty'}
    assert assigns(:movie_info)
    assert_template :movie_list
  end
end
