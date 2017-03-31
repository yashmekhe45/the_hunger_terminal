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
    authorize! :place_orders, :order_management
    if SendOrderMailJob.perform_now(params[:terminal_id], @orders, @order_details, params[:message])
      flash[:notice] = "emails sent successfully"
    else
      flash[:error] = "error in sending mails"
    end
  end

  private
    def load_details
      @order_details = Order.daily_orders(params[:terminal_id],current_user.company_id)
      @orders = Order.menu_details(params[:terminal_id],current_user.company_id).as_json
    end
end