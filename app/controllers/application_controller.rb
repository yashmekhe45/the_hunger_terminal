class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    if current_user.role == "company_admin"
      p "======COMPANY ADMIN======="
      terminals_path
    elsif current_user.role == "employee"
      p "==========employee========="
      terminals_path # REDIRECT TO PLACE ORDER PATH
    end 
  end
end
