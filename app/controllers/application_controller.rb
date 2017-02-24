class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    if current_user.role == "company_admin"
      company_terminals_path(current_user.company_id)
    end
  end
end
