require 'test_helper'

class MoviesControllerTest < ActionController::TestCase
  def setup
    set_net_stubs
  end
  
  test 'routes exist' do
    assert_routing({path: '/movie', method: :post}, {controller: 'movies', action: 'create'})
  end
  
  describe 'searching for movies' do
    before do
      devise_sign_in users(:user_1)
    end

    it 'works with and without entry' do
      post :create, {q: ' '}
      assert_template :new

      assert_difference('Movie.count', 20) do
        post :create, {q: 'man'}
      end
      assert assigns(:movie_list)
      assert assigns(:movie_list_partial)
      
      assert_no_difference('Movie.count') do
        post :create, {q: 'man'}
      end

      assert_operator assigns(:movie_list).size, :>, 0

      assert_select 'li', 20
    end

    it 'works when the movies are already in db' do
      post :create, {q: 'Man'}
      assert_select 'li', 2
    end
  end      
end
