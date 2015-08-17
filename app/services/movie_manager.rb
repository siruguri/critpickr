module MovieManager
  class Sorter
    def self.add_to_sort_list(user, movie)
      # user has to be a User object
      if movie.nil?
        return
      end

      if movie.is_a? String
        movie_obj = Movie.find_by_movie_name movie
        movie = movie_obj
      end

      # Else, we'll assume movie is a Movie obj

      end_index = MovieSortOrderEntry.where(user: user).count + 1
      
      # This will fail silently if the movie is already in the user's list; it will add the movie
      # at the end o/w
      MovieSortOrderEntry.create(user: user, movie: movie, sort_position: end_index)
    end
  end
end
