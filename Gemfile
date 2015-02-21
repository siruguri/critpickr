# -*- coding: utf-8 -*-
source 'https://rubygems.org'
ruby '2.2.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~>4.2'

gem 'quiet_assets'
gem 'thin'

# Admin Interface
gem 'rails_admin'

# Use SCSS for stylesheets
gem 'sass-rails', '=5.0.0.beta1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Needed for default layouts
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'underscore-rails'

# Adding Doorkeeper
gem 'doorkeeper'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'devise', git: 'https://github.com/plataformatec/devise.git', :branch => 'lm-rails-4-2'
gem 'haml-rails'
gem 'cancan'

gem 'resque-web', require: 'resque_web'
gem 'resque-scheduler'

group :production do
  gem 'pg'
  gem 'activerecord-postgresql-adapter'
  # Uncomment this for Heroku
  # gem 'rails_12factor'
end

gem 'therubyracer'
gem 'less-rails'

group :development do
  # Rails 4.2 Web Console!
  gem 'web-console', '~> 2.0'

  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  gem 'capistrano',  '~> 3.1'
  gem 'capistrano-rails', '~> 1.1'
  # integrate bundler with capistrano
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
  gem 'capistrano-passenger'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'pry'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'pry-byebug'
end

#testing with minitest
group :test do
  gem 'minitest-spec-rails'
  gem 'minitest-rails-capybara'
  gem 'capybara-webkit'
  gem 'mocha'
  gem 'simplecov', require: false
end
