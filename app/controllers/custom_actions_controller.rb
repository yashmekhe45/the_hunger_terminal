class CustomActionsController < ApplicationController

  def index
  @res = Terminal.joins(:order).where('orders.date' => Date.today).group('terminals.id').select('terminals.name,terminals.min_order_amount,terminals.id, sum(total_cost) AS total') 		
  end

  def order_detail
  	@order_details = Order.joins(:user,:order_details).where('orders.date' => Date.today,'orders.terminal_id' => params[:terminal_id]).select('orders.id','users.name AS emp_name','order_details.menu_item_name AS menu,quantity').order("users.name ASC")
  end

  def confirm
    @order = Order.joins(:order_details).where('orders.date'=> Date.today,'orders.terminal_id' => params[:terminal_id]).group('order_details.menu_item_name').select('order_details.menu_item_name AS menu,sum(quantity) AS quantity')
  end
end