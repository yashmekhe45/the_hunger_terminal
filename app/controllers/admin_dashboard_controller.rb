class AdminDashboardController < ApplicationController

  before_action :load_details, only: [:place_orders, :forward_orders, :confirm_orders]

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
    @terminal = Terminal.find(params[:terminal_id])
    @orders = Order.menu_details(params[:terminal_id],current_user.company_id)
    if @orders.any?
      Order.update_status(@order_details)
    end
  end  

  def place_orders
    authorize! :place_orders, :order_management
    SendOrderMailJob.perform_now(params[:terminal_id], @orders, params[:message])
    flash[:notice] = "emails sent successfully"
    # if SendOrderMailJob.perform_now(params[:terminal_id], @orders, @order_details, params[:message])
    #   flash[:notice] = "emails sent successfully"
    # else
    #   flash[:error] = "error in sending mails"
    # end
  end

  def confirm_orders
    authorize! :confirm_orders, :order_management
    Order.confirm_all_placed_orders(params[:terminal_id], current_user.company_id, @order_details)
    flash[:notice] = "all orders confirmed"
  end 


  private
    def load_details
      @order_details = Order.daily_orders(params[:terminal_id],current_user.company_id)
      @orders = Order.menu_details(params[:terminal_id],current_user.company_id).as_json
    end
end