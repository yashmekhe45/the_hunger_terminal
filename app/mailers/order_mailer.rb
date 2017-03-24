class OrderMailer < ApplicationMailer
  default from: ENV["GMAIL_USERNAME"]

  def send_mail_to_terminal(terminal_id, company_id)
    @terminal = Terminal.find(terminal_id)
    @orders = Order.menu_details(terminal_id, company_id)
    mail(to: @terminal.email, subject: 'orders for today')
  end

end
