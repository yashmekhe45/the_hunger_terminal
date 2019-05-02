class ApplicationController < ActionController::Base
  
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :load_vapid_public_key
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] =  "You are not authorized to access it!!"
    redirect_to vendors_path, flash[:alert] => exception.message
  
  end

  def after_sign_in_path_for(resource)
    if current_user.role == "company_admin"
      company_terminals_path(current_user.company_id)
    elsif current_user.role == "employee"
      vendors_path # REDIRECT TO PLACE ORDER PATH
    end 
  end

  def load_vapid_public_key
    @base64_vapid_public = Base64.urlsafe_decode64(ENV['VAPID_PUBLIC_KEY']).bytes
  end

end
