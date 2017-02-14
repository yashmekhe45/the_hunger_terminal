require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "email address must be present" do
    user = build(:user,:email => nil)
    user.valid?
    assert_not_empty user.errors[:email]
  end

  test "name must be present" do
    user = build(:user,:name => nil)
    user.valid?
    assert_not_empty user.errors[:name]
  end


  test "should have valid indian mobile number" do
    user = build(:user,:mobile_number => "1234567890")
    user.valid?
    assert user.errors[:mobile_number].include?("Please enter valid mobile number!")
  end
  #including +91, mobile number will be of 13 characters
  test "mobile number should have 13 characters " do
    user = build(:user, :mobile_number => "123")
    user.valid?
    assert user.errors[:mobile_number].include?("is the wrong length (should be 13 characters)")
  end 
end
