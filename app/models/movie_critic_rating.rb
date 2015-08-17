class MovieCriticRating < ActiveRecord::Base
  belongs_to :movie_critic
  belongs_to :movie
  
  validates_uniqueness_of :movie_id, scope: [:movie_critic_id]
end
