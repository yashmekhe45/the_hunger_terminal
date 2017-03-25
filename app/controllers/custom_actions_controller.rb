class CustomActionsController < ApplicationController

  def index
    @res = Terminal.daily_terminals(current_user.company_id) 		
  end

  def order_detail
  	@order_details = Order.daily_orders(params[:terminal_id],current_user.company_id)
  end

  def confirm
    @orders = Order.menu_details(params[:terminal_id],current_user.company_id)
  end

  def place_orders
    SendOrderMailJob.perform_now(params[:terminal_id], current_user.company_id)
    flash[:notice] = "email sent successfully"
    # Order.update_status(params[:terminal_id], current_user.company_id)
    redirect_to custom_actions_index_path
  end
end