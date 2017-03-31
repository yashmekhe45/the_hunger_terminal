class OrderMailer < ApplicationMailer
  default from: ENV["GMAIL_USERNAME"]

  def send_mail_to_terminal(terminal_id, terminal_orders,message)
    @terminal = Terminal.find(terminal_id)
    # @orders = Order.menu_details(terminal_id, company_id)
    @orders = terminal_orders
    @message = message
    mail(to: @terminal.email, subject: 'orders for today')
  end

  def send_mail_to_employees(employee)
    @employee = employee
    mail(to: employee, subject: 'status of order')
  end

end
