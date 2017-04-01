class AdminDashboardController < ApplicationController


  def index
    authorize! :index, :order_management
    @res = Terminal.daily_terminals(current_user.company_id)   
  end

  def order_detail
    authorize! :order_detail, :order_management
  	@order_details = Order.daily_orders(params[:terminal_id],current_user.company_id)  
  end

  def forward_orders
    authorize! :forward_orders, :order_management
    @orders = Order.menu_details(params[:terminal_id],current_user.company_id)  
  end

  def place_orders
    authorize! :place_orders, :order_management
    SendOrderMailJob.perform_now(params[:terminal_id], current_user.company_id)
    flash[:notice] = "email sent successfully"
    redirect_to admin_dashboard_index_path  
  end

  def confirm_orders
    authorize! :confirm_orders, :order_management
    Order.confirm_all_placed_orders(params[:terminal_id], current_user.company_id)
    flash[:notice] = "all orders confirmed"
  end 
end