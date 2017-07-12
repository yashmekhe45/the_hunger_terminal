require "test_helper"

class TerminalsControllerTest < ActionController::TestCase
  
  before :each do
    @terminal = create :terminal
    @company = @terminal.company
  end

  test "should not render index for non logged-in admin"  do
    get :index, params: {company_id: @company.id }
    assert_response :redirect
  end

  test "render index for logged-in admin" do
    sign_in_admin
    get :index, params: {company_id: @company.id}
    assert_response :success
  end

  test "should get new" do
    sign_in_admin
    get :new, params: {company_id: @company.id}
    assert_response :success  
  end


  test "should create terminal without uploading menu items" do
    sign_in_admin

    assert_difference 'Terminal.count' do
      post :create, params: 
      {terminal: { name: "kfc", email: "info@kfc.com", landline: "03456789089", payment_made: 0.0, min_order_amount: 50,tax: 0}, company_id: @company.id}
    end
  end


  test "should create terminal with uploading menu items" do
    sign_in_admin

    file_name = File.new(Rails.root.join("test/fixtures/files/menu.csv"))
    csv_file = Rack::Test::UploadedFile.new(file_name, 'text/csv')

    assert_difference 'Terminal.count' do
      post :create, params: 
      {terminal: { name: "kfc", email: "info@kfc.com", landline: "03456789089", payment_made: 0.0, min_order_amount: 50,tax: 0, CSV_menu_file: csv_file}, company_id: @company.id}
    end
  end

  test "should not create terminal" do
    sign_in_admin

    assert_difference 'Terminal.count', 0 do
      post :create, params: 
      {terminal: { name: "", email: "", landline: "", payment_made: 0.0, min_order_amount: 50,tax: 0}, company_id: @company.id}
    end
  end

  test "edit" do
    sign_in_admin
    get :edit, params: {id: @terminal.id}
    assert_response :success
    assert_template :edit
  end

  test "should update" do
    sign_in_admin
    patch :update, params:
     {terminal: { name: "kfc", email: "info@kfc.com", landline: "03456789089", payment_made: 0.0, min_order_amount: 50,tax: 0}, id: @terminal.id}
    assert_response :redirect
    assert_redirected_to company_terminals_url(@company)
  end

  test "should download invalid sample csv file" do
    sign_in_admin
    # get 
    get :download_invalid_csv, params: {terminal_id: @terminal.id}
    assert_response :success
  end

  test "should not update for invalid record" do
    sign_in_admin
    patch :update, params:
     {terminal: { name: "", email: "", landline: "", payment_made: 0.0, min_order_amount: 50,tax: 0}, id: @terminal.id}
    assert_response :success
  end


  test "terminal records should be searched" do
    sign_in_admin
    get :index, params: {company_id: @company.id, search: "dummy"}
    assert_response :success
  end

  def sign_in_admin
    admin = @company.employees.find_by(role: "company_admin")
    admin.confirm
    sign_in admin
  end

end
