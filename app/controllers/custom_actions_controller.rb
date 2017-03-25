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
    OrderMailer.send_mail_to_terminal(params[:terminal_id], current_user.company_id).deliver_now
    flash[:notice] = "email sent successfully"
    Order.update_status(params[:terminal_id], current_user.company_id)
    redirect_to custom_actions_index_path
  end
end