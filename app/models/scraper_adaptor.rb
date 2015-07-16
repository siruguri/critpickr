class ScraperAdaptor < ActiveRecord::Base
  def uri
    original_uri
  end

  def save_payload!(payload)
    self.payload = payload
    self.save!
  end
end
