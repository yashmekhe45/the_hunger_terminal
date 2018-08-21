module OrdersHelper

  def full_star(rating)
    rating.round / 2
  end

  def half_star?(rating)
    rating.round % 2 == 1
  end

  def empty_star(rating)
    (5 - (rating.round / 2) - rating % 2).round
  end

  def min_order_reached?(terminal, order_id = nil)
    return true if terminal.min_order_amount == 0
    terminal.min_order_amount <= terminal.ordered_amount(order_id)
  end

end
