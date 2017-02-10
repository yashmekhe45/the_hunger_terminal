require "test_helper"

class AddressTest < ActiveSupport::TestCase
  # def address
  #  @address ||= Address.new
  # end

  # def test_valid
  #   assert address.valid?
  # end

  test "house_no should be present" do
    address = FactoryGirl.build(:address,:house_no => nil)
    address.valid?
    assert_not_empty address.errors[:house_no]
  end
  test "pincode should be present" do
    address = FactoryGirl.build(:address,:pincode => nil)
    address.valid?
    assert_not_empty address.errors[:pincode]
  end
  test "locality should be present" do
    address = FactoryGirl.build(:address,:locality => nil)
    address.valid?
    assert_not_empty address.errors[:locality]
  end
  test "city should be present" do
    address = FactoryGirl.build(:address,:city => nil)
    address.valid?
    assert_not_empty address.errors[:city]
  end
  test "state should be present" do
    address = FactoryGirl.build(:address,:state => nil)
    address.valid?
    assert_not_empty address.errors[:state]
  end
  test "pincode should be numeric" do
    address = FactoryGirl.build(:address, :pincode => 'k')
    address.valid?
    assert address.errors[:pincode].include?("is not a number")
  end

  test "pincode should have 6 digits" do
    address = FactoryGirl.build(:address)
    address.valid?
    assert address.errors[:pincode].include?("is the wrong length (should be 6 characters)")
  end
end
