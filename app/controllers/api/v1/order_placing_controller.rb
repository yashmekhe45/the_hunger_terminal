class Api::V1::OrderPlacingController < ApiController

	before_action :load_company, only: [ :order_bill ]
  before_action :load_terminal, only: [ :order_bill ]

	def order_bill
  	@total_price = 0
  	permitted_params[:data].each do |key, value|
    	if @invalid_data == 0
    		if Terminal.find_by(id: params[:terminal_id].to_i).menu_items.exists?(key)
    			prices = Terminal.find_by(id: params[:terminal_id].to_i).menu_items.find_by(id: key.to_i).price
    			@total_price = @total_price + (prices * value)
    		else
    			@invalid_data = 1
    		end
      else
        break
      end
  	end
  	if @invalid_data == 0
	  	@bag_tax = @terminal.tax
	  	if @bag_tax == nil
	  		@bag_tax = 0
	  	end
	  	@bag_discount = @current_company.subsidy
	  	@total_payable = ( @total_price.to_i + @bag_tax.to_i ) - @bag_discount.to_i
	  	if @total_payable < 0
	  		@total_payable = 0
	  	end 	
  		render json: OrderPlacingSerializer.new(@terminal, { params: { bag_total: @total_price, bag_tax: @bag_tax, bag_discount: @bag_discount, total_payable: @total_payable }}), status: 200
  	else
  		render json: { message: "Invalid details provided!" }, status: 401
  	end
	end

	private

  def load_company
    @current_company = @current_user.company
  end

  def load_terminal
  	if Terminal.exists?(params[:terminal_id].to_i)
  		@terminal = @current_company.terminals.find params[:terminal_id]
  		@invalid_data = 0
  	else
  		@invalid_data = 1
  	end
  end

  def permitted_params
  	params.require(:cart).permit(:terminal_id).tap do |whitelisted|
      whitelisted[:data] = params[:cart][:data]
    end
  end
  
end
