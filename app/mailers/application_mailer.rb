class ApplicationMailer < ActionMailer::Base
  default from: "hunger-terminal@joshsoftware.com"
          reply_to: "kiranbdesh123@gmail.com"
  layout 'mailer'
end
