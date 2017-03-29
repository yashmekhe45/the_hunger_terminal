class AdminDashboardController < ApplicationController

  before_action :load_details, only: [:place_orders]

  def index
    @res = Terminal.daily_terminals(current_user.company_id)
    authorize! :index, :order_management 
  end

  def order_detail
  	@order_details = Order.daily_orders(params[:terminal_id],current_user.company_id)
    authorize! :order_detail, :order_management
  end

  def confirm
    @orders = Order.menu_details(params[:terminal_id],current_user.company_id)
    authorize! :confirm, :order_management
  end

  def place_orders
    SendOrderMailJob.perform_now(params[:terminal_id], @orders, @order_details)
    flash[:notice] = "email sent successfully"
    redirect_to admin_dashboard_index_path
    authorize! :place_orders, :order_management
  end

  private
    def load_details
      @order_details = Order.daily_orders(params[:terminal_id],current_user.company_id)
      @orders = Order.menu_details(params[:terminal_id],current_user.company_id)
    end
end