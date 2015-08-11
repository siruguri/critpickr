CritPickr::Application.routes.draw do

  # I like having this to populate the navbar with, via the database rather than do it in the views.
  resources :navbar_entries

  # Logins and Profiles
  devise_for :users
  resources :job_records, only: [:index]
  resources :scraper_requests, only: [:index, :new, :create]

  resource :movie, only: [:new, :create] do
    collection do
      post :set_sort
      get :movie_list
    end
  end

  # The rest of the routes file is specific to this app and you will have to manipulate it for your app. The 
  # 404 catchall route below always has to be at the end, if you intend to use it as designed in this app.

  # Admin - these routes sould ideally be protected with a constraint
  require 'sidekiq/web'
  # authenticate :admin, lambda { |u| u.is_a? Admin } do
  mount Sidekiq::Web => '/sidekiq_ui'
  # Adds RailsAdmin
  mount RailsAdmin::Engine => '/rails_admin', as: 'rails_admin'

  #end

  # Need a catch all to redirect to the errors controller, for catching 404s as an exception
  match "*path", to: "errors#catch_404", via: [:get, :post]
end
