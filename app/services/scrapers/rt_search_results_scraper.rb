module Scrapers
  class RtSearchResultsScraper < GenericScraper
    def payload_map
      @payload_map ||=
      {data: [ ], # We don't care about data on this page.
       links: [{pattern: 'a.articleLink',
                value: :search_results_list,
                page_extraction_class: 'RtMovieScraper',
                db_adaptor: 'Movie'}]}
    end
  end    
end
