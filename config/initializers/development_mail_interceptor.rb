class DevelopmentMailInterceptor 
  def self.delivering_email(message)
    # message.subject = ""  
    message.to = ["vaibhav.thombare@joshsoftware.com"]
  end
end
