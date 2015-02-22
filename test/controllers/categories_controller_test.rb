require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  # Tests for tasks controller
  include Devise::TestHelpers
  
  test 'can see list of categories' do
    sign_in(users(:user1))
            
    get :index
    assert_template :index
    assert assigns(:categories)
  end
end
