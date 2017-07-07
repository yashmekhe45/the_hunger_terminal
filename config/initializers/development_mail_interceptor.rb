class DevelopmentMailInterceptor 
  def self.delivering_email(message)
    # message.subject = ""  
    message.to = ["kirand@joshsoftware.com"]
  end
end