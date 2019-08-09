class Api::V1::VendorListingController < ApiController

  def load_terminals
    @terminals = Terminal.where(active: true, company: @current_user.company)
      .select(:id, :name, :image, :min_order_amount,
      :tax, 'avg(reviews.rating) as rating', :active)
      .left_outer_joins(:reviews)
      .group(:id)
      .order('rating desc nulls last')
      @end_ordering_at = @current_user.company.end_ordering_at.strftime('%H:%M:%S')
      render json: TerminalSerializer.new(@terminals, { params: {end_ordering_at: @end_ordering_at}}).serialized_json, status: 200
  end

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