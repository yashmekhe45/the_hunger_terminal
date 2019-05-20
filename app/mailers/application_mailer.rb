class ApplicationMailer < ActionMailer::Base
  default from: ENV["SENDER_MAIL"], reply_to: "hr@joshsoftware.com"
  layout 'mailer'
end
