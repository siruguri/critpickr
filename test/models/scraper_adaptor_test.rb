require 'test_helper'
class ScraperAdaptorTest < ActiveSupport::TestCase
  def setup
    @new_adaptor = ScraperAdaptor.new(original_uri: 'http://www.hello.com')
  end

  test 'alias for URI works' do
    assert_equal 'http://www.hello.com', @new_adaptor.uri
  end

  test 'payload saving works' do
    @new_adaptor.save_payload!({a: 1, b: 2})
    assert @new_adaptor.persisted?
  end
end
