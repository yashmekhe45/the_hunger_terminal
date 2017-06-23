require "test_helper"

class MenuItemsControllerTest  < ActionController::TestCase

  before :each do
    @menu_item = create(:menu_item)
    @terminal = @menu_item.terminal
    @company = @terminal.company
  end

  test "should not render index for non logged-in admin"  do
    get :index, params: {terminal_id: @terminal.id }
    assert_response :redirect
  end

  test "render index for logged-in admin" do
    sign_in_admin
    get :index, params: {terminal_id: @terminal.id }
    assert_response :success
  end


  test "should get new" do
    sign_in_admin
    get :new, params: {terminal_id: @terminal.id }, format: 'js', xhr: true
    assert_response :success  
  end

  test "should create menu item " do
    sign_in_admin

    assert_difference 'MenuItem.count' do
      post :create, params: 
      {menu_item: { name: "veg biryani", price: 100, description: "", veg: 'true', active_days: ['1','2', '3','4', '5'], available: '1'}, terminal_id: @terminal.id}, format: 'js', xhr: true
    end
  end

  test "should not create menu item" do
    sign_in_admin

    assert_difference 'Terminal.count', 0 do
      post :create, params: 
       {menu_item: { name: "", price: 100, description: "", veg: '', active_days: [], available: ''}, terminal_id: @terminal.id}, format: 'js', xhr: true
    end
  end



  test "edit" do
    sign_in_admin
    get :edit, params: {terminal_id: @terminal.id, id: @menu_item.id}, format: 'js', xhr: true
    assert_response :success
    assert_template :edit
  end

  test "should update" do
    sign_in_admin
    menu_item_name_before_update = @menu_item.name

    patch :update, params:
    {menu_item: { name: "veg biryani", price: @menu_item.price, description: @menu_item.description, veg: @menu_item.veg, active_days: @menu_item.active_days, available: @menu_item.available}, terminal_id: @terminal.id, id: @menu_item.id}, format: 'js', xhr: true
    
    menu_item_after_update = MenuItem.find(@menu_item.id)
    assert_not_equal menu_item_name_before_update, menu_item_after_update.name
  end

  test "should not update for invalid record" do
    sign_in_admin
    menu_item_name_before_update = @menu_item.name
    patch :update, params:
      {menu_item: { name: "", price: 0, description: "", veg: 'true', active_days: [], available: '1'}, terminal_id: @terminal.id, id: @menu_item.id}, format: 'js', xhr: true
    menu_item_after_update = MenuItem.find(@menu_item.id)
    assert_equal menu_item_name_before_update, menu_item_after_update.name
  end

   test "menu item records should be searched" do
    sign_in_admin
    get :index, params: {terminal_id: @terminal.id, search_item: "dummy"}
    assert_response :success
  end



  def sign_in_admin
    admin = @company.employees.find_by(role: "company_admin")
    admin.confirm
    sign_in admin
  end


end
