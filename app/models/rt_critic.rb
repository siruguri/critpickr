class RtCritic < ActiveRecord::Base
  has_many :rt_critic_ratings, dependent: :destroy
end
