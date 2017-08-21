class OrderMailer < ApplicationMailer

  def send_mail_to_terminal(terminal_id, terminal_orders, message, company_id)
    @terminal = Terminal.find(terminal_id)
    @company = Company.find(company_id)
    @orders = terminal_orders
    @message = message
    mail(to: @terminal.email, subject: 'Orders for today')
  end

  def send_mail_to_employees(employee)
    email = employee[0]
    @name = employee[1]
    mail(to: email, subject: 'Status of Order')
  end

  def send_place_order_reminder(employee, end_time)
    @end_time = end_time
    @employee_name = employee.name
    email = employee.email
    create_one_click_orders(employee.id)
    mail(to:email, subject: '[The Hunger Terminal] Place your order')
  end


  private

  def create_one_click_orders(employee_id)
    #For now, we are sending last three orders for one click ordering
    user = User.find(employee_id)
    @orders =  user.orders.includes(:order_details).confirmed.last(3).reverse
    @one_click_orders = []

    @orders.each do |order|
      @one_click_orders << order.one_click_orders.create(user_id: user.id) 
      terminal_image = "/uploads/terminal/image/hotelplaceholder1.jpg"
      if order.terminal['image'].present?
        terminal_image  = order.terminal.image_url(:thumb) 
      end
      image_url = "#{Rails.root}/public" + terminal_image
      attachments.inline["#{order.id}.jpg"] = File.read(image_url)
    end
  end
end
