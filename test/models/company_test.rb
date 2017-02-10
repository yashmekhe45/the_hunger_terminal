require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  def company
    @company ||= Company.new
  end

  # def test_valid
  #   assert_not company.valid?, "saved company record without any attribute"
  # end

  test "name should be present" do
    company_obj = FactoryGirl.build(:company,:name => nil)
    company_obj.valid?
    assert_not_empty company_obj.errors[:name]
  end

  test "landline should be present" do
    company_obj = FactoryGirl.build(:company,:landline => nil)
    company_obj.valid?
    assert company_obj.errors[:landline].include?("can't be blank")
  end

  
  test "landline should be unique" do
    company = FactoryGirl.build(:company)
    duplicate_record =company.dup
    company.save(validate: false)
    duplicate_record.valid?
    # assert duplicate_record.errors
    assert duplicate_record.errors[:landline].include?("has already been taken")
  end


  test "name should be unique under case insensitive scope" do
    company = FactoryGirl.build(:company)
    duplicate_record =company.dup
    duplicate_record[:name] = company[:name].upcase
    company.save(validate: false)
    duplicate_record.valid?
    assert duplicate_record.errors[:name].include?("has already been taken")
  end


  test "landline should be valid indian landline number" do
    company = FactoryGirl.build(:company, :landline => 'k')
    company.valid?
    assert company.errors[:landline].include?("Please enter valid landline number!")
  end

  test "landline should have 12 characters " do
    company = FactoryGirl.build(:company)
    company.valid?
    assert company.errors[:landline].include?("is the wrong length (should be 12 characters)")
  end 
end
