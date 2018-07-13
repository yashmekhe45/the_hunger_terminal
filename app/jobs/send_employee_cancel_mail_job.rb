class SendEmployeeCancelMailJob < ApplicationJob
  queue_as :default

  def perform(employee_id, terminals)
    OrderMailer.send_order_cancel_employees(employee_id, terminals).deliver_now
  end
  
end
