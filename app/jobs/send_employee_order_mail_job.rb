class SendEmployeeOrderMailJob < ApplicationJob
  queue_as :default

  def perform(employee_id)
    OrderMailer.send_mail_to_employees(employee_id).deliver_now
  end
  
end
