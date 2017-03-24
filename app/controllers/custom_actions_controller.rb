class CustomActionsController < ApplicationController

  def index
    @res = Terminal.daily_terminals(current_user.company_id) 		
  end

  def order_detail
  	@order_details = Order.daily_orders(params[:terminal_id],current_user.company_id)
  end

  def confirm
    @order = Order.menu_details(params[:terminal_id],current_user.company_id)
  end
end