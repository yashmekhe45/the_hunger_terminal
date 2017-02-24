class DevelopmentMailInterceptor 
  def self.delivering_email(message)
    # message.subject = ""  
    message.to = ["akshay.25kakade@gmail.com"]
  end
end