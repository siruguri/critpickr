require 'test_helper'

class WebArticleTest < ActiveSupport::TestCase
  test 'Validations work' do
    assert WebArticle.new(original_url: 'http://not.auri.com').valid?
    assert WebArticle.new(original_url: 'https://not.auri.com').valid?
    assert_not WebArticle.new(original_url: 'not a uri').valid?
  end
end
