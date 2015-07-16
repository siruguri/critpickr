class GenericScraperJob < ActiveJob::Base
  queue_as :scrapers

  def perform(record, klass_name_string)
    # record should respond to :uri and :parse_payload
    j = JobRecord.create(job_name: klass_name_string, status: 'started')

    if record.respond_to?(:uri) and record.respond_to?(:save_payload!)
      begin
        klass = klass_name_string.constantize
        obj = klass.new record.uri
        payload = obj.create_payload
      rescue Scrapers::DomFailure
        status = 'scraper failed'
      rescue SocketError, URI::InvalidURIError => e
        status = "OpenURI failed with #{e.message}"
      else
        obj.post_process_payload if obj.respond_to? :post_process_payload
        record.save_payload!(obj.payload[:data_root])
        status = "Success starting setting #{obj.payload[:data_root][:ratings].inspect} keys"
      end
    else
      status = 'Bad argument passed to job'
    end

    j.status = status
    j.save
  end
end

