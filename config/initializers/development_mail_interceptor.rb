class DevelopmentMailInterceptor 
  def self.delivering_email(message)
    message.to = ["meenakshi@joshsoftware.com, kirand@joshsoftware.com"]
  end
end