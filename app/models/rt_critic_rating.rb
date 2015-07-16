class RtCriticRating < ActiveRecord::Base
  belongs_to :rt_critic
  belongs_to :movie, class_name:'RtMovieEntry', foreign_key: 'rt_movie_entry_id'

  validates_uniqueness_of :rt_movie_entry_id, scope: [:rt_critic_id]
end
