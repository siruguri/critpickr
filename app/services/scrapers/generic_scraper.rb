require 'open-uri'

module Scrapers
  class GenericScraper
    attr_reader :payload, :crawl_links, :rules_json
    def initialize(uri_string, rules_json)
      @uri_string = uri_string
      @rules_json = rules_json
      
      @payload = {}
      @crawl_links = {}
    end

    def has_links?
      @_has_links ||= (@crawl_links.keys.select { |k| @crawl_links[k]['links'].size > 0 }.size > 0)
    end

    def payload_data
      @payload[:data_root]
    end

    def safe_dom(link=nil)
      @_dom || set_dom!(link)
    end
    
    def set_dom!(link = nil)
      link_to_use = link || @uri_string
      unless link_to_use.nil? or (link.nil? and @_dom)
        str = Net::HTTP.get URI(link_to_use)
        @_dom = SafeDom.new Nokogiri::HTML.parse(str)
      end

      @_dom
    end

    def create_payload
      rules = JSON.parse rules_json
      if rules['data'] and rules['data'].size > 0
        # If there is at least one rule to parse
        set_dom!
        # Default payload
        title = ''
        begin
          title = safe_dom.try_css('title').text
        rescue Scrapers::DomFailure => e
          title = "Blank Title Element"
        end
        
        @payload[:data_root] = {title: title}
        build_payloads(@_dom, rules['data'], @payload[:data_root])
        build_links(@_dom, rules['links']) if rules['links']
      end
      
      @payload
    end

    def scrape_later(db_rec)
      GenericScraperJob.perform_later self, db_rec
    end

    private
    def build_links(safe_dom, link_list)
      link_list.each do |link_rule|
        local_name = link_rule['value']
        
        @crawl_links[local_name] = {'scraper_registration_name' => link_rule['scraper_registration_name'],
                                    'db_adaptor' => link_rule['db_adaptor'] || 'ScraperAdaptor',
                                    'links' => []}
        
        links = safe_dom.try_css(link_rule['pattern'])
        links.each do |ahref|
          if ahref.respond_to?(:text) and ahref.respond_to?(:[])
            @crawl_links[local_name]['links'] << [ahref[:href], ahref.text]
          end
        end
      end
    end
    
    def build_payloads(safe_dom, rules, extracted_data)
      rules.each do |rule|
        next unless rule.is_a? Hash
        begin
          elts = safe_dom.try_css(rule['pattern'])
        rescue DomFailure => e
        else
          extracted_data[rule['value']] = []
          if rule['children']
            # Next step: consider an extraction at the top of the recursion as well; for now, we just descend from patterns
            # that have children
            elts.each do |elt|
              extracted_data[rule['value']] << {}
              build_payloads(SafeDom.new(elt), rule['children'], extracted_data[rule['value']].last)
              # The extraction might have failed - we are not guaranteed that the child rules will apply to every parent

              if extracted_data[rule['value']].last == {}
                extracted_data[rule['value']].pop
              end
            end
          else
            elts.each do |elt|
              if rule['extraction']
                extraction_actors = rule['extraction']
              else
                extraction_actors = [{'function' => :text, 'args' => []}]
              end
              bits = []
              extraction_actors.each do |actor|
                if elt.respond_to? actor['function']
                  if actor['args'].empty?
                    bit = elt.send(actor['function'])
                  else
                    bit = elt.send(actor['function'], *actor['args'])                    
                  end
                  bits << bit.strip if bit
                end
              end
              extracted_data[rule['value']] << bits.join(' ')
            end
            # End of recursion base case
          end
        end
        # End of successful extraction of dom for each rule
      end
      # End of running all rules
    end
    # End of build_payloads
  end
  # End of GenericScraper class
end
