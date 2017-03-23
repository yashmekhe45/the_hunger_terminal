class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def after_sign_in_path_for(resource)
    if current_user.role == "company_admin"
      terminals_path
    elsif current_user.role == "employee"
      root_path # REDIRECT TO PLACE ORDER PATH
    end 
  end
end
