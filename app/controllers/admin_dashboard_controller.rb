class AdminDashboardController < ApplicationController

  before_action :load_details, only: [:place_orders, :forward_orders, :confirm_orders]
  before_action :load_terminal, only: [:place_orders, :forward_orders]

  def index
    authorize! :index, :order_management
    @res = Terminal.daily_terminals(current_user.company_id)
    # the overall status of all orders of each terminal
    @placed = []
    @confirmed = []
    @res.each do |terminal|
      status = Order.get_all_orders_status(terminal.id)
      @placed << status.all? { |status| status == "placed" }
      @confirmed << status.all? { |status| status == "confirmed" }
    end
  end

  def order_detail
    authorize! :order_detail, :order_management
  	@order_details = Order.daily_orders(params[:terminal_id], current_user.company_id)  
  end

  def forward_orders
    authorize! :forward_orders, :order_management
    
    respond_to do |format|
      format.html { redirect_to admin_dashboard_index_path}
      format.js {}
    end
  end  

  def place_orders
    authorize! :place_orders, :order_management
    unless @terminal.email.blank?
      SendOrderMailJob.perform_now(params[:terminal_id], @orders, params[:message], current_user.company_id)
      flash[:notice] = "email sent successfully"
    end
    # @orders = Order.menu_details(params[:terminal_id], current_user.company_id)
    if @orders.any?
      Order.update_status(@order_details)
    end
  end

  def confirm_orders
    authorize! :confirm_orders, :order_management
    Order.confirm_all_placed_orders(params[:terminal_id], current_user.company_id, @order_details)
    flash[:notice] = "all orders confirmed"
    redirect_to admin_dashboard_index_path
  end 


  private
    def load_details
      @order_details = Order.daily_orders(params[:terminal_id], current_user.company_id)
      @orders = Order.menu_details(params[:terminal_id], current_user.company_id).as_json
    end

    def load_terminal
      @terminal = Terminal.find(params[:terminal_id])
    end

end