require 'test_helper'

class RedirectFor404Test < Capybara::Rails::TestCase
  # General test for 404 response
  test '404 redirects to sign in page if not going back' do
    visit '/not_a_route_at_all'
    assert_equal root_path, current_path
  end
end
