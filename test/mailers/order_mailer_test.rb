require "test_helper"

class OrderMailerTest < ActionMailer::TestCase


  before :all do
    ActionMailer::Base.deliveries.clear
    @company = create(:company)
    @user = @company.employees.select(:email, :name, :id)[0]
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

    #We are checking all the conditions for only one mail
  test "send place order reminder to employees if terminal image present" do
    terminal = create(:terminal, company: @company)
    stub_request_if_terminal_image_present(terminal.id)
    
    file_name = File.new(Rails.root.join("test/fixtures/files/hotelplaceholder1.jpg"))
    terminal_image = ActionDispatch::Http::UploadedFile.new({:tempfile => file_name, :filename => File.basename(file_name) })
    terminal_image.content_type = "image/jpeg"
    terminal.update(image: terminal_image) 

    create_past_order_for_user(terminal)
    ordering_end_time  = @company.end_ordering_at.strftime('%I:%M %p')

    ActionMailer::Base.deliveries = []
    email = OrderMailer.send_place_order_reminder(@user,ordering_end_time).deliver_now

    assert_not_empty ActionMailer::Base.deliveries
    assert_equal ["hunger-terminal@joshsoftware.com"], email.from
    assert_equal [@user.email], email.to
    assert_equal '[The Hunger Terminal] Place your order', email.subject
  end

   #We are checking all the conditions for only one mail
  test "send place order reminder to employees if terminal image not present" do
    stub_request_if_terminal_image_absent

    terminal = create(:terminal, company: @company)
    create_past_order_for_user(terminal)
    ordering_end_time  = @company.end_ordering_at.strftime('%I:%M %p')
    
    ActionMailer::Base.deliveries = []
    email = OrderMailer.send_place_order_reminder(@user,ordering_end_time).deliver_now

    assert_not_empty ActionMailer::Base.deliveries
    assert_equal ["hunger-terminal@joshsoftware.com"], email.from
    assert_equal [@user.email], email.to
    assert_equal '[The Hunger Terminal] Place your order', email.subject
  end

  test "send place order reminder if no past order is present" do
    stub_request_if_terminal_image_absent
    terminal = create(:terminal, company: @company)
    ordering_end_time  = @company.end_ordering_at.strftime('%I:%M %p')
    
    ActionMailer::Base.deliveries = []
    email = OrderMailer.send_place_order_reminder(@user,ordering_end_time).deliver_now

    assert_not_empty ActionMailer::Base.deliveries
    assert_equal ["hunger-terminal@joshsoftware.com"], email.from
    assert_equal [@user.email], email.to
    assert_equal '[The Hunger Terminal] Place your order', email.subject
  end

  test 'send order cancel mail to employees if terminal image not present' do
    stub_request_if_terminal_image_absent
    terminal = [create(:terminal, company: @company)]
    email = OrderMailer.send_order_cancel_employees(@user.id,terminal).deliver_now
    assert_not_empty ActionMailer::Base.deliveries
    assert_equal ["hunger-terminal@joshsoftware.com"], email.from
    assert_equal [@user.email], email.to
    assert_equal 'Order is cancelled', email.subject
  end

  test 'send order cancel mail to employees if terminal image present' do
    terminals = [create(:terminal, company: @company)]
    terminals.each |terminal| do
      stub_request_if_terminal_image_present(terminal.id)
      file_name = File.new(Rails.root.join("test/fixtures/files/hotelplaceholder1.jpg"))
      terminal_image = ActionDispatch::Http::UploadedFile.new({:tempfile => file_name, :filename => File.basename(file_name) })
      terminal_image.content_type = "image/jpeg"
      terminal.update(image: terminal_image)
    end
    email = OrderMailer.send_order_cancel_employees(@user.id,terminals).deliver_now
    assert_not_empty ActionMailer::Base.deliveries
    assert_equal ["hunger-terminal@joshsoftware.com"], email.from
    assert_equal [@user.email], email.to
    assert_equal 'Order is cancelled', email.subject
  end

  private

  def stub_request_if_terminal_image_present(terminal_id)
    stub_request(:put, "https://hunger-terminal.s3.ap-south-1.amazonaws.com/test/uploads/terminal/image/#{terminal_id}/hotelplaceholder1.jpg").to_return(status: 200, body: "", headers: {})
    stub_request(:put, "https://hunger-terminal.s3.ap-south-1.amazonaws.com/test/uploads/terminal/image/#{terminal_id}/thumb_hotelplaceholder1.jpg").to_return(status: 200, body: "", headers: {})
    stub_request(:get, "http://hunger-terminal.s3.amazonaws.com/test/uploads/terminal/image/#{terminal_id}/thumb_hotelplaceholder1.jpg").to_return(status: 200, body: "", headers: {})
  end

  def stub_request_if_terminal_image_absent()
   stub_request(:get, "http://hunger-terminal.s3.amazonaws.com/test/uploads/terminal/image/hotelplaceholder1.jpg").to_return(status: 200, body: "", headers: {})
  end

  def create_past_order_for_user(terminal)
    some_date = Time.new(2017,01,02)# 1st Jan
    Time.stub(:now, some_date) do
      create(:order, status: 'confirmed',user: @user, terminal:terminal, company: @company)
    end
  end

end
