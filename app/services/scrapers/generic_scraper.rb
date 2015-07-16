require 'open-uri'

module Scrapers
  class GenericScraper
    attr_reader :payload
    def initialize(uri_string=nil)
      @uri_string = uri_string
      @payload = {}
    end

    def payload_data
      @payload[:data_root]
    end
    
    def get_dom(link = nil)
      return nil if link.nil? && @uri_string.nil?
      if link.nil? and @_dom
          return @_dom
      end

      handle = open (link.nil? ? @uri_string : link)
      @_dom = SafeDom.new(Nokogiri::HTML.parse(handle.readlines.join('')))
    end

    def create_payload
      get_dom
      # Default payload
      @payload[:data_root] = {title: get_dom.try_css('title').text}

      if (self.respond_to?(:payload_map))
        @payload[:data_root] = {}
        build_payloads(@_dom, payload_map[:data], @payload[:data_root])
      end
      
      @payload
    end

    def scrape_later(db_rec)
      klass_string = self.class.to_s

      GenericScraperJob.perform_later(db_rec, klass_string)
    end

    private
    def build_payloads(safe_dom, rules, extracted_data)
      rules.each do |rule|
        begin
          elts = safe_dom.try_css(rule[:pattern])
        rescue DomFailure => e
        else
          if rule[:children]

            # Next step: consider an extraction at the top of the recursion as well; for now, we just descend from patterns
            # that have children
            extracted_data[rule[:value]] = []
            elts.each do |elt|
              extracted_data[rule[:value]] << {}
              build_payloads(SafeDom.new(elt), rule[:children], extracted_data[rule[:value]].last)
              # The extraction might have failed - we are not guaranteed that the child rules will apply to every parent

              if extracted_data[rule[:value]].last == {}
                extracted_data[rule[:value]].pop
              end
            end
          else
            extracted_data[rule[:value]] = []
            elts.each do |elt|
              if rule[:extraction]
                extraction_actors = rule[:extraction]
              else
                extraction_actors = [{function: :text, args: []}]
              end
              bits = []
              extraction_actors.each do |actor|
                if elt.respond_to? actor[:function]
                  if actor[:args].empty?
                    bits << elt.send(actor[:function])
                  else
                    bits << elt.send(actor[:function], *actor[:args])
                  end
                end
              end
              extracted_data[rule[:value]] << bits.join(' ')
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
