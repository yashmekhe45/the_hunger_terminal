class OrderMailer < ApplicationMailer

  def send_mail_to_terminal(terminal_id, terminal_orders, message, company_id)
    @terminal = Terminal.find(terminal_id)
    @company = Company.find(company_id)
    @orders = terminal_orders
    @message = message
    mail(to: @terminal.email, subject: 'orders for today')
  end

  def send_mail_to_employees(employee)
    email = employee[0]
    @name = employee[1]
    mail(to: email, subject: 'status of order')
  end

  def send_place_order_reminder(employee, end_time)
    @end_time = end_time
    #employee is an array
    email = employee[0]
    @name = employee[1]
    employee_id = employee[2]

    @one_click_orders = Array.new
    #For now, we are sending last three orders for one click ordering
    @orders =  Order.includes(:order_details).where(user_id: employee_id, status: "confirmed").last(3)
    @orders.each_with_index do |order, index|
      @one_click_orders << OneClickOrder.create(user_id: employee_id, order_id: order.id)
      if order.terminal['image'].present?
        terminal_image = "#{Rails.root}/app/assets/images/#{order.terminal['image']}"
        attachments.inline["#{index}.jpg"] = File.read(terminal_image)
      end
    end

    mail(to:email, subject: 'place order soon')
  end

end
