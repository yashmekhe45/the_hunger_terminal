require "test_helper"

class CompanyTest < ActiveSupport::TestCase

  test "name should be present" do
    company_obj = build(:company,:name => nil)
    company_obj.valid?
    assert_not_empty company_obj.errors[:name]
  end

  test "landline should be present" do
    company_obj = build(:company,:landline => nil)
    company_obj.valid?
    assert company_obj.errors[:landline].include?("can't be blank")
  end
  
  test "landline should be unique" do
    company = create(:company)
    duplicate_record = build(:company,:landline =>company.landline)
    duplicate_record.valid?
    assert duplicate_record.errors[:landline].include?("has already been taken")
  end

  test "name should be unique under case insensitive scope" do
    company = create(:company)
    duplicate_record = build(:company)
    duplicate_record[:name] = company[:name].upcase
    duplicate_record.valid?
    assert duplicate_record.errors[:name].include?("has already been taken")
  end

  test "landline should be valid indian landline number" do
    company = build(:company,:landline => 'k')
    company.valid?
    assert company.errors[:landline].include?('please enter valid landline no eg.022-20316523')
  end

  test "landline should have 12 characters " do
    company = build(:company, :landline => '6128')
    company.valid?
    assert company.errors[:landline].include?("is the wrong length (should be 12 characters)")
  end 

  test "address should be present" do
    # address1 = build(:address)
    company = build(:company, :landline => "0233-1234567")
    company.address = nil
    company.valid?
    assert company.errors[:address].include?("can't be blank")
  end
end
