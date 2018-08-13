module OrdersHelper

  def min_order_reached?(terminal, order_id = nil)
    return true if terminal.min_order_amount == 0
    terminal.min_order_amount <= terminal.ordered_amount(order_id)
  end

end
