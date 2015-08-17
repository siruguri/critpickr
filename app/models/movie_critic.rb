class MovieCritic < ActiveRecord::Base
  has_many :movie_critic_ratings, dependent: :destroy
end
