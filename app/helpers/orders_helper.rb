module OrdersHelper

  def full_star(rating)
    rating / 2
  end

  def half_star?(rating)
    rating % 2 == 1
  end

  def empty_star(rating)
    5 - rating / 2 - rating % 2
  end

  def min_order_reached?(terminal, order_id = nil)
    return true if terminal.min_order_amount == 0
    terminal.min_order_amount <= terminal.ordered_amount(order_id)
  end

  def skipped?(order)
    order.skipped_review
  end
end
