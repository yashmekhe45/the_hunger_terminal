class OrdersController < ApplicationController
  
  def index
    @orders = current_user.orders 
  end

  def load_terminal
    @terminals = Terminal.where(active: true, company: current_user.company)
  end

  def new
    @order = Order.new  
    @terminal_id = params[:terminal_id]
    @menu_items = MenuItem.where(terminal_id: params[:terminal_id])
    
  end

  def create
    @order = Order.new(order_params)
    load_order_detail
    if @order.save
      redirect_to @order
    else
      flash[:error] = @order.errors.messages
      render :new
    end
  end
  
  def show
    @order = Order.find(params[:id])
  end
  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to vendors_path
  end
  private

  def order_params
    params.require(:order).permit(
      :total_cost,:terminal_id, order_details_attributes:[:menu_item_id, :quantity]
    ).merge(user_id: current_user.id)
  end

  def load_order_detail
    @order.date = Date.today
    @order.company_id = current_user.company.id
  end

end
