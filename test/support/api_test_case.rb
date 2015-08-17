class APITestCase < ActiveSupport::TestCase
  include Rack::Test::Methods

  HOST = 'http://www.rails-app.dev/api'
  alias :rack_get :get
  alias :rack_post :post
  alias :rack_delete :delete

  def app
    Rails.application
  end

  def get(path, args = nil)
    rack_get(HOST + path, args)
  end

  def post(path, args = nil)
    rack_post(HOST + path, args)
  end

  def delete(path)
    rack_delete(HOST + path)
  end

  def authenticate(user)
    token = mock
    token.stubs(:acceptable?).returns(true)
    token.stubs(:resource_owner_id).returns(user.id)
    Doorkeeper.stubs(:authenticate).returns(token)
    WineBouncer::OAuth2.any_instance.stubs(:doorkeeper_token).returns(token)
    [token, user]
  end
end
