require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  # Tests for tasks controller
  include Devise::TestHelpers
  
  test 'root routes to tasks index' do
    assert_recognizes({controller: 'tasks', action: 'index'}, '/')
  end

  test 'can see list of tasks' do
    get :index
    assert_template :index
    assert assigns(:tasks)
  end
end
