class DevelopmentMailInterceptor 
  def self.delivering_email(message)
    # message.subject = ""  
    message.to = ENV["DEVELOPER_MAIL"]
  end
end
