require "test_helper"

class OrderMailerTest < ActionMailer::TestCase

  before :all do
    ActionMailer::Base.deliveries.clear
    @company = create(:company)
    @users = @company.employees.select(:email, :name, :id)
    @user = @users[0]
  end

  test "send order mail to terminal" do
    terminal = create(:terminal)
    message = "Hi"
    order = create(:order, terminal: terminal, company: terminal.company, date: Time.zone.today, status: 'pending')
    order.order_details
    terminal_orders = Order.menu_details(terminal.id, terminal.company_id).as_json
    email = OrderMailer.send_mail_to_terminal(terminal.id, terminal_orders, message, @company.id).deliver_now
    assert_not_empty ActionMailer::Base.deliveries
    assert_equal ["hunger-terminal@joshsoftware.com"], email.from
    assert_equal [terminal.email], email.to
    assert_equal 'Orders for today', email.subject
  end

  test "send confirmed order status mail to employee" do
    #We are checking all the conditions for only one mail
    email = OrderMailer.send_mail_to_employees(@user.id).deliver_now
    assert_not_empty ActionMailer::Base.deliveries
    assert_equal ["hunger-terminal@joshsoftware.com"], email.from
    assert_equal [@user.email], email.to
    assert_equal 'Status of Order', email.subject
  end
end
