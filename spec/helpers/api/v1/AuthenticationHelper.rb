require 'json'
module AuthenticationHelper  
  def auth_token_for_user(user)
    data = signin(user)
    if data == 0
      return nil
    else
      return data
    end
  end

  def signin(user)
    @user_validate = User.find_by( email: user.email )
    if !(User.find_by( email: user.email))
      return 0
    end
    if @user_validate.valid_password?(user.password)
      return generate_auth_token_for_users(@user_validate)
    else
      return 0
    end
  end

  def generate_auth_token_for_users(user)
    payload = { user_id: user.id } 
    exp = 1.hours.from_now
    payload[:exp] = exp.to_i
    JWT.encode(payload, "JOSH", "HS256")
  end

end
