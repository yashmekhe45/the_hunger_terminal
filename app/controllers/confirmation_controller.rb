class ConfirmationController < Devise::ConfirmationsController

  skip_before_filter :authenticate_user!

  def after_confirmation_path_for(resource_name, resource)
    if resource.role == "employee"
      p "in after confirmation block"
      @token = Devise.token_generator.generate(User, :reset_password_token)
      p @token
      edit_password_url(resource, reset_password_token: @token)
    else
      super
    end
  end
end
