module TmdbApiWrapper
  class TmdbApiWrapperException < Exception
  end

  class Client
    def initialize(api_key:)
      @_api_key = api_key
    end

    def search_movie(query:)
      if query.strip.length == 0
        raise TmdbApiWrapperException, "Query length in search after removing spaces cannot be zero"
      end
      
      uri = URI(keyed_url("/search/movie") + "&query=#{URI.encode(query.strip)}")

      str = Net::HTTP.get uri
      JSON.parse str 
    end

    private  
    def endpoint_url
      ENV['TMDB_ENDPOINT_URL'] || 'http://api.themoviedb.org/3'
    end
    
    def keyed_url(path)
      endpoint_url + path + "?api_key=#{@_api_key}"
    end
  end
end
