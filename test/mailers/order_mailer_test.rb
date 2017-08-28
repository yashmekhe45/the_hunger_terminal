require "test_helper"

class OrderMailerTest < ActionMailer::TestCase

  before :all do
    ActionMailer::Base.deliveries.clear
    @company = create(:company)
    @users = @company.employees.select(:email, :name, :id)
    @user = @users[0]
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
