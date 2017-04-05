class OrdersController < ApplicationController

  load_and_authorize_resource  param_method: :order_params
  before_action :require_permission, only: [:show, :edit, :update, :delete]

  def index
    @from_date = params[:from] || 7.days.ago.strftime('%y-%m-%d')
    @to_date = params[:to] || Date.today.strftime('%y-%m-%d')
    @orders = current_user.orders.where(date: Date.parse(@from_date)..Date.parse(@to_date)).order(date: :desc)
    if @orders.empty?
      flash[:error] = "No order is present for this period!"
    end
  end

  def load_terminal
    @terminals = Terminal.where(active: true, company: current_user.company)
  end

  def new
    @order = Order.new  
    @terminal_id = params[:terminal_id]
    @menu_items = MenuItem.where(terminal_id: params[:terminal_id]).where("active_days @> ARRAY[?]::varchar[]",[Time.zone.now.wday.to_s]).where(available: true)
  end

  def create
    @order = Order.new(order_params)
    load_order_detail
    if @order.save
      redirect_to @order
    else
      if @order.errors.full_messages.include?("User has already been taken")
        flash[:error] = "Only one order is allowed per day"
      else
        flash[:error] = @order.errors.full_messages.join(",")
      end 
      redirect_to vendors_path
    end
  end

  def show
     @order = Order.find(params[:id])
  end


  def edit
    @order = Order.find(params[:id])
    @terminal_id = params[:terminal_id]
  end

  def update
    @order = Order.find(params[:id])
    p order_params
    # @order.order_details = OrderDetail.where(params[:order_id])
    # @order.order_details.clear
    if @order.update_attributes(order_params)
      redirect_to @order
    else
      render 'edit'
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to vendors_path

  end
  
  private

    def order_params
      params.require(:order).permit(
        :total_cost,:terminal_id, order_details_attributes:[:menu_item_id, :quantity, :id]
      ).merge(user_id: current_user.id)
    end

    def load_order_detail
      @order.date = Time.zone.today
      @order.company_id = current_user.company.id
    end

    def require_permission
      if current_user != Order.find(params[:id]).user
        flash[:error] = "You are not authorized to access it!!"
        redirect_to root_path
      end
    end

end
