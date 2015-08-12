class DbModelNoUri
end

class DummyDbRecord
  attr_reader :ratings

  include GlobalID::Identification
  
  def id
    1
  end
  
  def initialize(inp='http://someuri')
    @original_uri = inp
  end
    
  def self.find_or_create_by(original_uri:)
    return self.send :new, original_uri
  end
  
  def original_uri
    @original_uri || 'http://someuri'
  end
  def save_payload!(hash)
    @ratings = hash['key']
  end

  def self.create(opts={})
    @count ||= 0
    @count += 1
  end

  def self.count
    @count ||= 0
  end
end
  
