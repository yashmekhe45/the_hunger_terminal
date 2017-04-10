class SendOrderMailJob < ApplicationJob
  queue_as :default

  def perform(t_id, orders, message)
    OrderMailer.send_mail_to_terminal(t_id, orders,message).deliver_later
  end
end
