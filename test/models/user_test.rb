require "test_helper"

class UserTest < ActiveSupport::TestCase

  before :each do
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

  test "role must be present" do
    @user.role = nil
    @user.valid?
    assert @user.errors[:role].include?("can't be blank")
  end

  test "should have valid indian mobile number" do
   @user.mobile_number = "123ABC890"
    @user.valid?
    assert @user.errors[:mobile_number].include?("Enter valid mobile no.")
  end

  test "mobile number should have 10 characters " do
    @user.mobile_number = "123"
    @user.valid?
    assert @user.errors[:mobile_number].include?("is the wrong length (should be 10 characters)")
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


  test "user email should be unique in a company" do
    @company = create(:company)
    @employee = @company.employees.first
    @duplicate_employee = build(:user)
    @duplicate_employee.company_id = @company.id
    @duplicate_employee.email = @employee.email
    @duplicate_employee.valid?
    assert @duplicate_employee.errors[:email].include?("user email should be unique in a company")
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

  test "company must be present for an employee" do
    @user.role = "employee"
    @user.valid?
    assert @user.errors[:company_id].include?("can't be blank")
  end


end
