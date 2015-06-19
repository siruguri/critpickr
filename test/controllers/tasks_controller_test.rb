require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  # Tests for tasks controller
  include Devise::TestHelpers

  def setup
    sign_in :user, users(:user1)

    @task_to_update = tasks(:task1_user1)
  end
    
  test 'root routes to tasks index' do
    assert_recognizes({controller: 'tasks', action: 'index'}, '/tasks')
    assert_routing '/', {controller: 'tasks', action: 'index'}
    assert_routing '/tasks/new', {controller: 'tasks', action: 'new'}
  end

  test 'can see list of tasks' do
    get :index
    assert_template :index
    assert assigns(:tasks)
  end

  test 'new task screen is defaulted to 2 days from now' do
    get :new
    assert assigns(:task)
    assert_equal Date.today + 2.days, assigns(:task).due_date
  end

  test 'create tasks works' do
    assert_difference('Task.count', 1) do
      post :create, good_task_params
    end
  end

  test 'create tasks works with category ids' do
    assert_difference('TaskCategorization.count', 1) do
      post :create, good_task_with_categories_params
    end
  end
  
  test 'update task works' do
    patch :update, {id: @task_to_update.id}.merge(good_task_params)

    assert_redirected_to task_path(@task_to_update)
    t = Task.find(@task_to_update.id)
    assert_equal @task_to_update.title + ' (new)', t.title
  end

  test 'bad update params fails gracefully' do
    patch :update, {id: 'notanid', task: {title: @task_to_update.title + ' (new)'}}
    assert_redirected_to tasks_path
  end

  test 'AR invalid update params fails gracefully' do
    patch :update, {id: @task_to_update.id, task: {title: @task_to_update.title + ' (new)'}}
    assert_template :edit
    assert_equal :errors_found, flash[:alert]
  end

  private
  def good_task_params
    {task: {title: @task_to_update.title + ' (new)', due_date: '2016-01-01'}}
  end

  def good_task_with_categories_params
    t = good_task_params
    t[:task][:category_ids] = [categories(:category1_user1).id, ""]

    t
  end
end
