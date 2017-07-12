
require "test_helper"

class UserTest < ActiveSupport::TestCase

  before :each do
    DatabaseCleaner.start
    @user = build(:user)
  end

  #Devise automatically validates email. Thus, no need to write validation for it.

  test "name must be present" do
    @user.name = nil
    @user.valid?
    assert @user.errors[:name].include?("can't be blank")
  end

  test "mobile number must be present" do 
    @user.mobile_number = nil
    @user.valid?
    assert @user.errors[:mobile_number].include?("can't be blank")
  end

  test "mobile number should have 10 characters " do
    @user.mobile_number = "123"
    @user.valid?
    assert @user.errors[:mobile_number].include?("is the wrong length (should be 10 characters)")
  end 

  test "user mobile number must be unique in a company" do
    @company = create(:company)
    @employee = @company.employees.first
    @duplicate_employee = build(:user)
    @duplicate_employee.company_id = @company.id
    @duplicate_employee.mobile_number = @employee.mobile_number
    @duplicate_employee.valid?
    assert @duplicate_employee.errors[:mobile_number].include?("user mobile number should be unique in a company") 
  end

  test "should have valid indian mobile number" do
   @user.mobile_number = "123ABC890"
    @user.valid?
    assert @user.errors[:mobile_number].include?("Enter valid mobile no.")
  end

  test "role must be present" do
    @user.role = nil
    @user.valid?
    assert @user.errors[:role].include?("can't be blank")
  end

  test "role must have value from given array" do
    @user.role = "dummy"
    @user.valid?
    assert @user.errors[:role].include?("is not included in the list")
  end

  test "is_active must have a boolean value" do
    @user.is_active = "dummy"
    @user.valid?
    assert @user.errors[:is_active].include?("This must be true or false.")
  end


  test "company must be present for an employee" do
    @user.role = "employee"
    @user.company = nil
    @user.valid?
    assert @user.errors[:company].include?("can't be blank")
  end

  test "employees' running balance report should be generated" do
    user = create(:user_with_orders)
    user.orders.each do |order|
      order = nil
    end
    company_id = user.company_id
    user2 = build(:user)
    user2.company_id = company_id
    user2.save!
    company = Company.find(company_id)
    company.employees << user2
    report = User.employee_report(company_id)
    assert_equal report, []
  end

  test "employees' today's report should be generated" do
    user1 = create(:user) # created an user who don't have order for today
    company_id = user1.company_id
    user2 = build(:user)
    user2.company_id = company_id
    user2.save!
    report = User.employees_todays_orders_report(company_id)
    assert_equal report, []
  end

  test "employees' last month report should be generated" do
    user = create(:user) # created an user who don't have any last month report
    company_id = user.company_id
    user2 = build(:user)
    user2.company_id = company_id
    user2.save!
    report = User.employee_last_month_report(company_id, Time.now - 1.month)
    assert_equal report, []
  end

  test "individual employee's last month report should be generated" do
    user = create(:user) # created an user who don't have any last month report
    company_id = user.company_id
    report = User.employee_last_month_report(company_id, user.id)
    assert_equal report, []
  end

  test "employees' record should be imported " do
    company = create(:company, name: 'dummy')
    prev_user_count = company.employees.count
    #CSV file should be imported
    file_name = File.new(Rails.root.join("test/fixtures/files/employees.csv"))
    csv_file = ActionDispatch::Http::UploadedFile.new({
    :tempfile => file_name, :filename => File.basename(file_name) })
    csv_file.content_type = "application/csv"
    csv_import = User.import(csv_file, company.id)
    now_user_count = company.employees.count
    assert_equal now_user_count - prev_user_count, 1   
  end

  test "uploaded file should have csv/xls/xlsx type" do
    file_name = File.new(Rails.root.join("test/fixtures/files/employees.csv"))
    csv_file = ActionDispatch::Http::UploadedFile.new({
    :tempfile => file_name, :filename => File.basename(file_name) })
    csv_file.content_type = "application/csv"
    assert_nothing_raised { User.open_spreadsheet(csv_file) } 
  end

  test "invalid file type should not be imported" do
    file_name = File.new(Rails.root.join("test/fixtures/files/employees.txt"))
    txt_file = ActionDispatch::Http::UploadedFile.new({
    :tempfile => file_name, :filename => File.basename(file_name)})
    assert_raises { User.open_spreadsheet(csv_file) } 
  end


  test "user should belong to a company" do
  end

  test "user has many orders" do
  end

end