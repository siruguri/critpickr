class StatusMailer < ActionMailer::Base
  default from: 'siruguri@gmail.com', subject: 'Status email from CritPickr'

  def scraper_email(status_mesg)
    @body = status_mesg
    mail to: Rails.application.secrets.status_email_recipient
  end
end
