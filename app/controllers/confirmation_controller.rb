class ConfirmationController < Devise::ConfirmationsController

  skip_before_action :authenticate_user!

  def after_confirmation_path_for(resource_name, resource)
    if resource.role == "employee"
     
      # To redirect to reset password path, we are generating reset password token manually
      raw, enc = Devise.token_generator.generate(User, :reset_password_token)
      resource.reset_password_token   = enc
      resource.reset_password_sent_at = Time.now
      resource.save
      edit_password_url(resource, reset_password_token: raw)
    else
      #after confirmation, you may log in 
      super
    end
  end
end
