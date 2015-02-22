require 'test_helper'
class TasksIntegrationTest < Capybara::Rails::TestCase
  # Testing screens for tasks

  include Warden::Test::Helpers
  Warden.test_mode!

  describe 'Logged in user' do
    before do
      @user = users(:user1)
      login_as(@user, :scope => :user)
    end

    it 'can see tasks assigned to them' do
      visit '/' # Root path goes to tasks#index
      page.assert_selector('table', count: 1)

      # Fixtures: user 1 has at least 2 tasks.
      page.assert_selector('tr', minimum: 3)

      page.has_no_content? 'user 2 task'
      page.has_content? 'user 1 task'
    end
  end  
end
