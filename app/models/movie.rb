class Movie < ActiveRecord::Base
  serialize :ratings, Array
  has_many :movie_critic_ratings, dependent: :destroy

  def self.search(query)
    rel = where('movie_name like ?', "%#{query}%")

    rel.count > 0 ? rel.all : nil
  end

  def self.add_from_tmdb!(tmdb_json_obj)
    ret_status = []
    begin
      ActiveRecord::Base.transaction do
        tmdb_json_obj['results'].each do |movie_data|
          existing = where(movie_name: movie_data['original_title'], release_date: movie_data['release_date'])
          if existing.count == 0
            m = Movie.new movie_name: movie_data['original_title'], release_date: movie_data['release_date']
            m.save
            ret_status << m
          else
            ret_status << existing[0]
          end
        end
      end
    rescue ActiveRecord::RecordInvalid
      ret_status = nil
    end

    ret_status
  end

  def display_name
    "<i>#{movie_name}</i> (#{release_date})".html_safe
  end
  
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

        crit = MovieCritic.find_or_create_by name: crit_hash[:name][0]
        rating = MovieCriticRating.new(original_score: orig_score, original_score_base: orig_score_base,
                                       tomato: tomato_img, movie: self, movie_critic: crit)
        if rating.valid? # Don't duplicate ratings
          crit.movie_critic_ratings << rating
        end
      end
    end
  end
end
