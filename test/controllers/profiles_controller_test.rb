require 'test_helper.rb'

class ProfilesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    devise_sign_in users(:user_1)
  end
  
  describe 'Getting the list' do
    it 'returns the list' do
      get :movie_sort_list
      assert assigns(:movie_data)
    end
  end
  
  describe 'selecting a movie' do
    it 'adds a movie that\'s not already there idempotently' do
      assert_difference('MovieSortOrderEntry.count') do
        post :set_sort, {commit: movies(:entry_1).movie_name}
      end
      assert_no_difference('MovieSortOrderEntry.count') do
        post :set_sort, {commit: movies(:entry_1).movie_name}
      end
    end
  end
end
