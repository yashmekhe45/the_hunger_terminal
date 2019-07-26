class Api::V1::SignInController < ApiController

	def signin
		@user = User.find_by( email: permitted_params[:email] )
		if !(@user)
			render json: { message:"User not found!" },status:404
			return
		end
		if @user.valid_password?(permitted_params[:password])      
			render json: { data: generate_auth_token, message:"Sign in successfull!" }, status: 200
		else
			render json: { message:"Sign in unsuccessful!" }, status: 404
		end
	end

	def generate_auth_token
		payload = { id: @user.id, exp: 1.hours.from_now }  
		JWT.encode(payload, "Secret_key", "HS256")
	end

	private 

	def permitted_params
		params.require(:user).permit(:email, :password)
	end

end
