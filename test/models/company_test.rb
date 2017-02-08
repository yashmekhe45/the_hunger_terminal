require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  def company
    @company ||= Company.new
  end

  # def test_valid
  #   assert_not company.valid?, "saved company record without any attribute"
  # end

  test "name must be present" do
    company_obj = FactoryGirl.build(:company,:name => nil)
    company_obj.valid?
    assert_not_empty company_obj.errors[:name]
  end

  test "landline must be present" do
    company_obj = FactoryGirl.build(:company,:landline => nil)
    company_obj.valid?
    assert_not_empty company_obj.errors[:landline]
  end

  #whether the dummy record is going to be stored in DB or not
  test "landline must be unique" do
    company = FactoryGirl.build(:company)
    duplicate_record =company.dup
    company.save(validate: false)
    duplicate_record.valid?
    # assert duplicate_record.errors
    assert_equal duplicate_record.errors[:landline], ["has already been taken"]
  end
end
