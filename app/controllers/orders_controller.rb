class OrdersController < ApplicationController
  
  def index
    @orders = current_user.orders
   
  end

   def load_menu_items
     @terminals = Terminal.where(is_active: true, company: current_user.company)
  end

  def new
    @order = Order.new
    #load_menu_items
    @menu_items = MenuItem.where(terminal_id: params[:terminal_id])
  end

  def create
    @order = Order.new(order_params)
    @order.date = Time.now
    if @order.save
      redirect_to @order
    else
      flash[:error] = @order.errors.messages
      #load_menu_items
      render :new
    end
  end
  
  def show
    @order = Order.find(params[:id])
  end
  private
  def order_params
    params.require(:order).permit(
      :total_cost, order_details_attributes:[:menu_item_id, :quantity]
    ).merge(user_id: current_user.id)
  end

 

end
