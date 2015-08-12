require 'test_helper'

class MoviesControllerTest < ActionController::TestCase
  def setup
    set_net_stubs
  end
  
  test 'routes exist' do
    assert_routing({path: '/movie', method: :post}, {controller: 'movies', action: 'create'})
  end
  
  describe 'posting' do
    before do
      devise_sign_in users(:user_1)
    end

    it 'works with and without entry' do
      post :create, {q: ' '}
      assert_template :new

      post :create, {q: 'man'}
      assert assigns(:movie_info)
      assert assigns(:movie_list_partial)

      assert_select 'li', 20
    end
  end
end
