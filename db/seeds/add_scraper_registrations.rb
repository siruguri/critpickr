newrec = ScraperRegistration.find_or_create_by(scraper_registration_name: 'RT Person Page Scraper')
newrec.scraper_json = ({"data" => [{"pattern":".info_list tr","value":"bio_info"}], "links" => []}).to_json
newrec.save


newrec = ScraperRegistration.find_or_create_by scraper_registration_name: 'RT Movie Page Scraper'
newrec.db_model = 'Movie'
newrec.scraper_json = ({"data":[{
                                  "pattern":".movie_title span[itemprop=name]","value":"movie_name"},
                                {"pattern":"#all-critics-numbers span[itemprop=ratingValue]","value":"allcrits_tomato_score"},
                                {"pattern":"#top-critics-numbers span[itemprop=ratingValue]","value":"topcrits_tomato_score"},
                                {"pattern":".audience-score span[itemprop=ratingValue]","value":"audience_tomato_score"},
                                {"pattern":".quote_bubble",
                                 "children":[
                                               {"pattern":"div[itemprop=reviewRating] span.icon","extraction":[{"function":"attr","args":["title"]},{"function":"attr","args":["class"]}],
                                                "value":"rating"},
                                               {"pattern":"div[itemprop=author] a",
                                                "value":"name"}],
                                 "value":"critic_data"}],
                        "links":[{"pattern":"table.info a.a","value":"person_list", "scraper_registration_name":"Rt Person Page Scraper"}]
                       }).to_json

newrec.save

s = ScraperRegistration.find_or_create_by scraper_registration_name: 'Wiki Scraper'
s.db_model = 'ScraperAdaptor'
s.scraper_json= ({"data": [{"pattern":".infobox.vcard tr", "value": "infobox_entries"}]}).to_json
s.save


