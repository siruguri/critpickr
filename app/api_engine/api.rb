require 'wine_bouncer'

class API < Grape::API
  format :json
  use ::WineBouncer::OAuth2

  rescue_from WineBouncer::Errors::OAuthUnauthorizedError do
    Rack::Response.new({
      id: 'unauthenticated',
      message: 'Request failed because user is not authenticated.'
    }.to_json, 401,  'Content-Type' => 'text/error').finish
  end

  rescue_from Grape::Exceptions::ValidationErrors  do |e|
    Rack::Response.new({
      id: 'invalid_parameters',
      message: 'The request was missing required parameters or passed invalid parameters.'
    }.to_json, 422, 'Content-Type' => 'text/error').finish
  end

  rescue_from ActiveRecord::RecordNotFound do
    Rack::Response.new({
      id: 'missing_record',
      message: 'The record you requested was not found.'
    }.to_json, 404,  'Content-Type' => 'text/error').finish
  end

  rescue_from :all do |e|
    Rack::Response.new({
      id: 'internal_error',
      message: "Internal server error #{e.message}. Check logs."
    }.to_json, 500,  'Content-Type' => 'text/error').finish
  end

  # WIP: Need to figure out better way to stub routes.
  if Rails.env.test?
    desc 'Raises error', auth: false
    get '/raises-error' do
      fail StandardError
    end

    get '/authenticated' do
      { id: 'should not see' }
    end
  end

  mount V0::ScraperRequest::Manage

  route :any, '*path', auth: false do
    error!({ id: 'not_found', message: 'Not Found.' }, 404)
  end
end

