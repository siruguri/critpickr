module Scrapers
  class RtMovieScraper < GenericScraper
    def payload_map
      @payload_map ||=
      {data: [{pattern: '.movie_title span[itemprop=name]',
               value: :movie_name
              },
              {pattern: '#all-critics-numbers span[itemprop=ratingValue]',
               value: :allcrits_tomato_score},
              {pattern: '#top-critics-numbers span[itemprop=ratingValue]',
               value: :topcrits_tomato_score},
              {pattern: '.quote_bubble',
               children: [
                 {pattern: 'div[itemprop=reviewRating] span.icon',
                  extraction: [{function: :attr, args: ["title"]}, {function: :attr, args: ['class']}],
                  value: :rating},
                 {pattern: 'div[itemprop=author] a',
                  value: :name
                 }
               ],
               value: :critic_data}
             ],
       links: [{pattern: 'table.info span[itemprop=genre]',
                value: :genre_list,
                scraper_job_class: 'RT_Genre_Scraper'}]}
    end

    def post_process_payload
      payload_data[:ratings] = (payload_data[:allcrits_tomato_score].nil? ? [] : payload_data[:allcrits_tomato_score] ) +
                               (payload_data[:topcrits_tomato_score].nil? ? [] : payload_data[:topcrits_tomato_score])
    end
  end    
end
