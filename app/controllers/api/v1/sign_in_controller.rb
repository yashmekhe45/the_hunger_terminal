class Api::V1::SignInController < ApiController
	
	skip_before_action :authenticate_request

 	def authenticate
   	command = AuthenticateUser.call(permitted_params[:email], permitted_params[:password])

   	if command.success?
     	render json: { auth_token: command.result, message: "Sign in Successful!" }, status: 200
   	else
     	render json: { error: command.errors, message: "Sign in Unsuccessful!" }, status: 404
   	end
 	end

 	private 

	def permitted_params
		params.require(:user).permit(:email, :password)
	end

end
