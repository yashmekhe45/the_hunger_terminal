require "test_helper"

class CompaniesControllerTest  < ActionController::TestCase
  test "should show company" do
    company = build(:company)
    get company_url(company)
    assert_response :success    
  end

 test "should destroy company" do
    company = build(:company)
    assert_difference('Company.count', -1) do
    delete company_url(company)
    end
    assert_redirected_to companies_path
  end

  test "should get index" do
    get companies_url
    assert_response :success
  end
end