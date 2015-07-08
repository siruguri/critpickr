require 'test_helper'
class UserSigninIntegrationTest < Capybara::Rails::TestCase
  # Testing screens for tasks

  include Warden::Test::Helpers
  Warden.test_mode!

  describe 'Logged in user' do
    before do
      @user = users(:user_1)
      login_as(@user, :scope => :user)
    end

    it 'can see logout link' do
      visit '/' # Root path goes to tasks#index
      page.has_content? 'Sign Out'
    end
  end  
end
