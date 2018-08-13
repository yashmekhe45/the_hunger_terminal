module OrdersHelper

  def min_order_reached?(terminal, order = false)
  	return true if terminal.min_order_amount == 0
	return terminal.min_order_amount <= terminal.ordered_amount if order == false
	terminal.ordered_amount - order.total_cost - order.tax > terminal.min_order_amount
  end

end
