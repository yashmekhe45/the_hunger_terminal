require "test_helper"

class OrderMailerTest < ActionMailer::TestCase

  test "send place order reminder to employees if terminal imgae present" do
    company = create(:company)
    terminal = create(:terminal, company: company)
    users = company.employees.select(:email, :name, :id)
    ordering_end_time  = company.end_ordering_at.strftime('%I:%M %p')
    ActionMailer::Base.deliveries = []

    file_name = File.new(Rails.root.join("test/fixtures/files/hotelplaceholder.jpg"))
    terminal_image = ActionDispatch::Http::UploadedFile.new({
    :tempfile => file_name, :filename => File.basename(file_name) })
    terminal_image.content_type = "image/jpeg"

    terminal.update(image: terminal_image)
    #We are checking all the conditions for only one mail
    user = users[0]
    create(:order,status: 'confirmed', company: company, user: user, terminal: terminal) # We are creating one order for this user
    email = OrderMailer.send_place_order_reminder(user,ordering_end_time).deliver_now
    assert_not_empty ActionMailer::Base.deliveries
    assert_equal ["hunger-terminal@joshsoftware.com"], email.from
    assert_equal [user.email], email.to
    assert_equal '[The Hunger Terminal] Place your order', email.subject
  end

  test "send place order reminder to employees if terminal image not present" do
    company = create(:company)
    terminal = create(:terminal, company: company, image: nil)
    users = company.employees.select(:email, :name, :id)
    ordering_end_time  = company.end_ordering_at.strftime('%I:%M %p')
    ActionMailer::Base.deliveries = []
    #We are checking all the conditions for only one mail
    user = users[0]
    create(:order,status: 'confirmed', company: company, user: user, terminal: terminal) # We are creating one order for this user
    email = OrderMailer.send_place_order_reminder(user,ordering_end_time).deliver_now
    assert_not_empty ActionMailer::Base.deliveries
    assert_equal ["hunger-terminal@joshsoftware.com"], email.from
    assert_equal [user.email], email.to
    assert_equal '[The Hunger Terminal] Place your order', email.subject
  end

end