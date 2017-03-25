class SendOrderMailJob < ApplicationJob
  queue_as :default

  def perform(t_id, c_id)
    OrderMailer.send_mail_to_terminal(t_id,c_id).deliver_now
    Order.update_status(t_id,c_id)
  end
end
