class Api::V1::OrderDetailsController < ApiController

	def order_history
  	@from_date = permitted_params[:from]
    @to_date = permitted_params[:to]
    if Date.parse(@from_date) > Date.parse(@to_date)
    	render json: { error: "From date must be less than To date!" }, status: 401
    else
	    @orders = @current_user.orders.includes(:terminal).includes(:order_details)
	    	.where(status: "confirmed",date: Date.parse(@from_date)..Date.parse(@to_date))
	    	.select(:id, :user_id, :company_id, :terminal_id, :status, :date, :total_cost, :tax, :discount, :extra_charges, :tax, 
	    		'(total_cost + tax + extra_charges - discount) as total_payable', 
	    		'(SELECT menu_item_name FROM order_details WHERE  order_id = orders.id) as menu_item_name', 
	    		'(SELECT quantity FROM order_details WHERE  order_id = orders.id) as quantity', :reviewed, :skipped_review)
	    	.order(date: :desc)
	    if @orders.empty?
	      render json: { message: "No order is present for this period!" }, status: 200
	    else
	    	render json: OrderDetailSerializer.new(@orders), status: 200
	    end
	  end
  end

  private

  def permitted_params
  	params.require(:duration).permit(:from, :to)
  end

end