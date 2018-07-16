require "test_helper"

class AdminDashboardControllerTest  < ActionController::TestCase

  before :each do
    @company = create(:company)
    @terminal1 = create(:terminal, company: @company)
  end

  test "should get all terminalwise orders" do 
    sign_in_admin 
    create_employees
    create_orders
    get :index
    assert_response :success
  end

  test "should get employeewise orders for a terminal" do
    sign_in_admin
    get :order_detail, params: {terminal_id: @terminal1.id}, format: 'js', xhr: true
    assert_response :success
  end

  #A modal displayes for a terminal contains total orderd menu items for that terminal
  test "should get all ordered menu items for a terminal" do
    sign_in_admin
    get :forward_orders, params: {terminal_id: @terminal1.id}, format: 'js', xhr: true
    assert_response :success
  end


  #sends mail containing all ordered menu items to a terminal
  test "should place orders" do
    sign_in_admin
    create_employees
    create_orders
    ActionMailer::Base.deliveries = []
    get :place_orders, params: {terminal_id: @terminal1.id}, format: 'js', xhr: true
    assert_response :success
    assert_not_empty ActionMailer::Base.deliveries
  end

  #here we have created orders for 2 employees
  test "should confirm orders" do
    sign_in_admin
    create_employees
    create_orders
    assert_enqueued_jobs 2 do
      get :confirm_orders, params: {terminal_id: @terminal1.id, todays_order_total: "1000"}
    end
    assert_response :redirect
    assert_redirected_to admin_dashboard_index_url
  end

  test "should input extra charges of terminals" do
    sign_in_admin
    get :input_terminal_extra_charges
    assert_response :success
  end

  test "should add extra charges of terminals" do
    sign_in_admin
    create_employees
    create_orders
    confirm_orders
    TerminalExtraCharge.destroy_all
    assert_difference 'TerminalExtraCharge.count' do
      post :save_terminal_extra_charges, params: {"terminal_extra_charges_form"=>[{"terminal_id"=>"#{@terminal1.id}", "daily_extra_charge"=>"10"}]}
    end
    assert_response :success
  end

  test "should not add extra charges of terminals if already added" do
    sign_in_admin
    create_employees
    create_orders
    confirm_orders
    terminal_extra_charge = create(:terminal_extra_charge, terminal: @terminal1, daily_extra_charge: 10, company: @company)
    assert_difference 'TerminalExtraCharge.count', 0 do
      post :save_terminal_extra_charges, params: {"terminal_extra_charges_form"=>[{"terminal_id"=>"#{@terminal1.id}", "daily_extra_charge"=>"10"}]}
    end
    assert_response :redirect
    assert_redirected_to admin_dashboard_index_url
  end

  test 'should cancel orders' do
    sign_in_admin
    create_employees
    create_orders
    assert_enqueued_jobs 2 do
      get :cancel_orders, params: {terminal_id: @terminal1.id, todays_order_total: "0"}
    end
    assert_response :redirect
    assert_redirected_to admin_dashboard_index_url
  end

  #This function has some issue. Will finish it by fixing the issue
  test "should destroy unavailable menu item record" do
  end

   #This function has some issue. Will finish it by fixing the issue
   test "should make payment to terminals" do
   end


  def sign_in_admin
    admin = @company.employees.find_by(role: "company_admin")
    admin.confirm
    sign_in admin
  end

  def create_employees
    @user1 = create(:user, company: @company)
    @user2 = create(:user, company: @company)
  end

  def create_orders
    @order1 = create(:order, company: @company, terminal: @terminal1, user: @user1)
    @order2 = create(:order, company: @company, terminal: @terminal1, user: @user2)
  end

  def confirm_orders
    @order1.update_attribute(:status, "confirmed")
    @order2.update_attribute(:status, "confirmed")
  end

  def cancel_orders
    @order1.destroy_all
    @order2.destroy_all
  end

end
