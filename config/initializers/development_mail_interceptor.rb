class DevelopmentMailInterceptor 
  def self.delivering_email(message)
    # message.subject = ""  
    message.to = ["tejaswini@joshsoftware.com"]
  end
end