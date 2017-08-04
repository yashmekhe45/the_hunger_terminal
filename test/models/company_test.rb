require "test_helper"

class CompanyTest < ActiveSupport::TestCase

  before :each do
    @company = build(:company)
  end

  test "name should be present" do
    @company.name = nil
    @company.valid?
    assert @company.errors[:name].include?("can't be blank")
  end

  test "name should be unique under case insensitive scope" do
    @company.save!
    duplicate_record = build(:company)
    duplicate_record[:name] = @company[:name].upcase
    duplicate_record.valid?
    assert duplicate_record.errors[:name].include?("has already been taken")
  end

  test "email should be present" do
    @company.email = nil
    @company.valid?
    assert @company.errors[:email].include?("can't be blank")
  end

 
  test "email should be unique" do
    @company.save!
    duplicate_record = build(:company, email: @company.email)
    duplicate_record.valid?
    assert duplicate_record.errors[:email].include?("has already been taken")
  end 

  test "email should follow valid regular expression" do
    @company.email = "dummy"
    @company.valid?
    assert @company.errors[:email].include?("is invalid")
  end

  test "landline should be present" do
    @company.landline = nil
    @company.valid?
    assert @company.errors[:landline].include?("can't be blank")
  end
  
  test "landline should be unique" do
    @company.save!
    duplicate_record = build(:company,:landline =>@company.landline)
    duplicate_record.valid?
    assert duplicate_record.errors[:landline].include?("has already been taken")
  end

  test "landline should be valid indian landline number" do
    @company.landline = 'k'
    @company.valid?
    assert @company.errors[:landline].include?('please enter valid landline no.')
  end

  test "landline should have 11 characters " do
    @company.landline ='6128'
    @company.valid?
    assert @company.errors[:landline].include?("is the wrong length (should be 11 characters)")
  end 
  

  test "subsidy should be a numeric value" do
    @company.subsidy = "non_numeric_val"
    @company.valid?
    assert @company.errors[:subsidy].include?("is not a number")
  end

  test "subsidy should not be less than zero" do
    @company.subsidy = -1
    @company.valid?
    assert @company.errors[:subsidy].include?("value must be between 0 to 100"), "Subsidy value is less than zero"
  end

  test "subsidy should not be greater than hundred" do
    @company.subsidy = 101
    @company.valid?
    assert @company.errors[:subsidy].include?("value must be between 0 to 100"), "Subsidy value is greater than hundred"
  end

  test "subsidy should be between zero to hundred" do
    @company.subsidy = 150
    @company.valid?
    assert @company.errors[:subsidy].include?("value must be between 0 to 100"),"Subsidy must be between 0 to 100"
 end

 test "subsidy should be present" do
    @company.subsidy = nil
    @company.valid?
    assert @company.errors[:subsidy].include?("can't be blank"), "Subsidy should be present" 
  end

  test "start ordering time should be present" do
    @company.start_ordering_at = nil
    @company.valid?
    assert @company.errors[:start_ordering_at].include?("can't be blank")
  end

  test "end ordering time should be present" do
    @company.end_ordering_at = nil
    @company.valid?
    assert @company.errors[:end_ordering_at].include?("can't be blank")
  end

  test "address should be present" do
    @company.address = nil
    @company.valid?
    assert @company.errors[:address].include?("can't be blank")
  end

  #This callback is called while updating the company
  test "company admin should be present" do
    @company = create(:company)
    @company.employees.first.update_attribute(:role, "employee")
    @company.subsidy = 10
    @company.valid?
    assert @company.errors[:employees].include?("company admin must be present")
  end 


  #This works when we send  mails inline
  test "reminder mail should be sent on working days" do
    company = create(:company, name: "Josh Software")
    users = create(:user_with_orders, company: company)
    ActionMailer::Base.deliveries = []
    company.send_reminders
    assert_not_empty ActionMailer::Base.deliveries
  end

end

