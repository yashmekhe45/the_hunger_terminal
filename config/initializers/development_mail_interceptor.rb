class DevelopmentMailInterceptor 
  def self.delivering_email(message)
    # message.subject = ""  
    message.to = ["shivam1995k@gmail.com, kirand@joshsoftware.com"]
  end
end