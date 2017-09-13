require "test_helper"

class OrderMailerTest < ActionMailer::TestCase

    #We are checking all the conditions for only one mail
  test "send place order reminder to employees if terminal image present" do
    terminal = create(:terminal)
    stub_request_if_terminal_image_present(terminal.id)
    
    file_name = File.new(Rails.root.join("test/fixtures/files/hotelplaceholder1.jpg"))
    terminal_image = ActionDispatch::Http::UploadedFile.new({:tempfile => file_name, :filename => File.basename(file_name) })
    terminal_image.content_type = "image/jpeg"
    terminal.update(image: terminal_image) 

    company = terminal.company
    user = company.employees.select(:email, :name, :id)[0]
    user.orders.create(status: 'confirmed', terminal:terminal, company: company)
    ordering_end_time  = company.end_ordering_at.strftime('%I:%M %p')

    ActionMailer::Base.deliveries = []
    email = OrderMailer.send_place_order_reminder(user,ordering_end_time).deliver_now

    assert_not_empty ActionMailer::Base.deliveries
    assert_equal ["hunger-terminal@joshsoftware.com"], email.from
    assert_equal [user.email], email.to
    assert_equal '[The Hunger Terminal] Place your order', email.subject
  end

   #We are checking all the conditions for only one mail
  test "send place order reminder to employees if terminal image not present" do
    stub_request_if_terminal_image_absent

    terminal = create(:terminal)
    company = terminal.company
    user = company.employees.select(:email, :name, :id)[0]
    user.orders.create(status: 'confirmed', terminal:terminal, company: company)
    ordering_end_time  = company.end_ordering_at.strftime('%I:%M %p')
    
    ActionMailer::Base.deliveries = []
    email = OrderMailer.send_place_order_reminder(user,ordering_end_time).deliver_now

    assert_not_empty ActionMailer::Base.deliveries
    assert_equal ["hunger-terminal@joshsoftware.com"], email.from
    assert_equal [user.email], email.to
    assert_equal '[The Hunger Terminal] Place your order', email.subject
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

end