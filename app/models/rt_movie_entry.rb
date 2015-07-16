class RtMovieEntry < ActiveRecord::Base
  serialize :ratings, Array
  has_many :rt_critic_ratings, dependent: :destroy
  
  def uri
    original_uri
  end

  def save_payload!(payload)
    self.ratings = payload[:ratings]
    self.movie_name = payload[:movie_name][0]
    self.save!
    
    payload[:critic_data].each do |crit_hash|
      if crit_hash[:name]
        matches = /(original score: ([\d.]+)\/(\d+))?.* (fresh|rotten)/i.match(crit_hash[:rating][0])
        if matches[3]
          # There's an orig score
          orig_score = matches[2].to_f
          orig_score_base = matches[3].to_i
        end
        tomato_img = matches[matches.size - 1]

        crit = RtCritic.find_or_create_by name: crit_hash[:name][0]
        rating = RtCriticRating.new(original_score: orig_score, original_score_base: orig_score_base,
                                       tomato: tomato_img, movie: self, rt_critic: crit)
        if rating.valid? # Don't duplicate ratings
          crit.rt_critic_ratings << rating
        end
      end
    end
  end
end
