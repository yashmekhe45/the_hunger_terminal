require "test_helper"

class ReportsControllerTest  < ActionController::TestCase

  before :each do
    @company = create :company
  end


  test "employees' orderwise report should be generated" do
    sign_in_admin
    get :employees_daily_order_detail
    assert_response :success
  end

  test "employees' orderwise report pdf should be generated" do
    sign_in_admin
    get :employees_daily_order_detail, format: 'pdf'
    assert_response :success
  end

  test "employees' last month report should be generated" do
    sign_in_admin
    get :monthly_all_employees
    assert_response :success
  end


  test "employees' current month running balance should be generated" do
    sign_in_admin
    get :employees_current_month
    assert_response :success
  end

  test "employee's current month orderwise history should be generated" do
    sign_in_admin
    create_user
    get :employee_history, params: {id: @user.id}
    assert_response :success
  end

  test "terminals' today's report should be generated" do
    sign_in_admin
    get :terminals_todays
    assert_response :success
  end

  test "terminals' today's report pdf should be generated" do
    sign_in_admin
    get :terminals_todays, format: 'pdf'
    assert_response :success
  end

  test "terminals' last month report should be generated" do
    sign_in_admin
    get :terminals_history
    assert_response :success 
  end

  def sign_in_admin
    admin = @company.employees.find_by(role: "company_admin")
    admin.confirm
    sign_in admin
  end

  

  def create_user
    @user = create(:user, company: @company)
  end

end

