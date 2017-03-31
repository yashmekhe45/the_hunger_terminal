class SendOrderMailJob < ApplicationJob
  queue_as :default

  def perform(t_id, orders, order_details,message)
    OrderMailer.send_mail_to_terminal(t_id, orders,message).deliver_later
    Order.update_status(order_details)
  end
end
