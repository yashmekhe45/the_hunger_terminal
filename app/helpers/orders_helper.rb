module OrdersHelper

  def min_order_reached?(terminal)
    terminal.min_order_amount <= terminal.ordered_amount
  end

end
