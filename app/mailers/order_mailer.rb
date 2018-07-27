require 'open-uri'
class OrderMailer < ApplicationMailer

  def send_mail_to_terminal(terminal_id, terminal_orders, message, company_id)
    @terminal = Terminal.find(terminal_id)
    @company = Company.find(company_id)
    @orders = terminal_orders
    @message = message
    mail(to: @terminal.email, subject: 'Orders for today')
  end

  def send_mail_to_employees(employee)
    user = User.select(:name, :email).find(employee)
    @name = user.name
    email = user.email
    mail(to: email, subject: 'Status of Order')
  end

  def send_order_cancel_employees(name, email, recommended_terminals)
    @terminals = recommended_terminals
    @name = name
    mail(to: email, subject: 'Order is cancelled')
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
    #For now, we are sending last three distinct orders for one click ordering
    @orders = []
    @orders =  OrderDetail.get_orders_for_one_click_ordering(employee_id)
    unless @orders.empty?
      @one_click_orders = []
      @orders.each do |order|
        @one_click_orders << order.create_one_click_order(employee_id)
        terminal_image = ImageUploader.default_url
        if order.terminal['image'].present?
          terminal_image  = order.terminal.image_url(:thumb)  
        end
        attachments.inline["#{order.id}.jpg"] = open(terminal_image).read
      end
    end
  end
end
