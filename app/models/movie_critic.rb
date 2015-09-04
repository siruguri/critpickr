class MovieCritic < ActiveRecord::Base
  has_many :movie_critic_ratings, dependent: :destroy
  has_many :movies, through: :movie_critic_ratings
end
