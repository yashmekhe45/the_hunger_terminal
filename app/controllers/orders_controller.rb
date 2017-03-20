class OrdersController < ApplicationController
  
  def index
    @orders = current_user.orders
  end

  def new
    @order = Order.new
    load_menu_items
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to orders_path
    else
      flash[:error] = @order.errors.messages
      load_menu_items
      render :new
    end
  end

  private
  def order_params
    params.require(:order).permit(
      :total_cost, order_details_attributes:[:menu_item_id, :quantity]
    ).merge(user_id: current_user.id)
  end

  def load_menu_items
     terminals_ids = Terminal.where(is_active: true, company: current_user.company).ids
     @menu_items = MenuItem.where(terminal_id: terminals_ids)
  end

end
