require 'test_helper'

class OrdersControllerTest < ActionController::TestCase

  before :each do
    @order_detail = create(:order_detail)
    @order = @order_detail.order
    @company = @order.company
  end

  test 'show order details to the company admin in employee report' do
    admin = @order.user
    admin.update(role: 'company_admin')
    admin.confirm
    sign_in admin
    get :show, params: {id: @order.id}
    assert_response :success
    assert_template :show
  end

  test 'do not show order details to employee in employee report' do
    employee = @company.employees.first
    employee.confirm
    sign_in employee
    get :show, params: {id: @order.id}
    assert_response :redirect
    assert_redirected_to root_path
  end

  test 'do not show order details to admin of another company in employee report' do
    @admin1 = create(:user, role: 'company_admin',
                            company_id: @order.company_id + 1)
    @admin1.confirm
    sign_in @admin1
    get :show, params: {id: @order.id}
    assert_response :redirect
    assert_redirected_to root_path
  end

end
