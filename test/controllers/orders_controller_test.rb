require "test_helper"

class OrdersControllerTest  < ActionController::TestCase

  before :each do
    @order = create(:order)
    @terminal = @order.terminal
    @company = @terminal.company
    @user1 = @order.user
    @user2 = create(:user, company: @company)
    @order_details = @order.order_details.all
    @menu_item_id = @order_details[0].menu_item_id
    @quantity = @order_details[0].quantity
  end

  test "should get new order" do
    sign_in_new_user
    get :new, params: {terminal_id: @terminal.id}
    assert_response :success
  end

  test "should create order" do
    sign_in_new_user
    quantity = 5
    assert_difference 'Order.count' do
      post :create, 
      params: 
      {
        "terminal_id"=> "#{@terminal.id}",
        order: 
        { total_cost: "120", terminal_id: "#{@terminal.id}", 
        order_details_attributes:
          {
            "#{@menu_item_id}"=> {menu_item_id: "#{@menu_item_id}", quantity: "#{quantity}" }
          }
        } 
      }
    end
  end

  test "should not create order" do
     sign_in_new_user
    assert_difference 'Order.count', 0 do
      post :create, 
      params: 
      {
        "terminal_id"=> "#{@terminal.id}",
        order: 
        { total_cost: "", terminal_id: "", 
        order_details_attributes:
          {
            "0"=> {menu_item_id: "", quantity: "" }
          }
        } 
      }
    end  
  end

  test "show" do
    sign_in_user_having_order
    get :show, params: {id: @order.id }
    assert_response :success
    assert_template :show
  end

  test "edit" do
    sign_in_user_having_order
    get :edit, params: {id: @order.id}
    assert_response :success
    assert_template :edit
  end

  test "should be updated by it's owner" do
    sign_in_user_having_order
    patch :update, 
    params:
    {
      "id"=> "#{@order.id}",
      order: 
      { 
        total_cost: "120", terminal_id: "#{@terminal.id}", 
        order_details_attributes:
          {
            "#{@menu_item_id}"=> {menu_item_id: "#{@menu_item_id}", quantity: "#{@quantity}", "id" =>"#{@order_details[0].id}" }
          }
      } 
    }
    assert_response :redirect
    assert_redirected_to order_path(@order)
  end

  test "should not be updated by other user" do
    sign_in_new_user
    patch :update, 
    params:
    {
      "id"=> "#{@order.id}",
      order: 
      { 
        total_cost: "120", terminal_id: "#{@terminal.id}", 
        order_details_attributes:
          {
            "#{@menu_item_id}"=> {menu_item_id: "#{@menu_item_id}", quantity: "#{@quantity}", "id" =>"#{@order_details[0].id}" }
          }
      } 
    }
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "destroy" do
    sign_in_user_having_order
    delete :destroy, params: {id: @order.id}
    assert_response :redirect
    assert_redirected_to vendors_url  
  end


  test "should display order history" do
    sign_in_user_having_order
    get :order_history
    assert_response :success
    assert_template :order_history
  end

  test "active terminals should be displayed" do
    sign_in_new_user
    get :load_terminal
    assert_response :success
    assert_template :load_terminal
  end


  def sign_in_user_having_order
    @user1.confirm
    sign_in @user1
  end
  def sign_in_new_user
    @user2.confirm
    sign_in @user2
  end


end