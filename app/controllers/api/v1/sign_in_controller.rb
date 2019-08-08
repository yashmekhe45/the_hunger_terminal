class Api::V1::SignInController < ApiController

	skip_before_action :authenticate_request

 	def authenticate
   	command = AuthenticateUser.new(permitted_params[:email], permitted_params[:password]).call
    if command
     	render json: { auth_token: command, message: "Sign in Successful!" }, status: 200
    else
    	render json: { auth_token: command, message: "Sign in Unsuccessful!" }, status: 404
   	end
 	end

 	private 

	def permitted_params
		params.require(:user).permit(:email, :password)
	end

end
