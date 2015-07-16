module Scrapers
  class WikipediaScraper < GenericScraper
    def payload_map
      @payload_map ||=
      {data: [{pattern: '.wikitable tr td:first-child a',
               value: :movie_name}
             ],
       links: []}
    end

    def post_process_payload
    end
  end    
end
