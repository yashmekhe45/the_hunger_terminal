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


test "should create terminal" do
  sign_in_admin

  assert_difference 'Terminal.count' do
    post :create, params: 
    {terminal: { name: "kfc", email: "info@kfc.com", landline: "03456789089", payment_made: 0.0, min_order_amount: 50,tax: 0}, company_id: @company.id}
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


#   test "should destroy terminal" do
#     assert_difference('Terminal.count', -1) do
#       delete terminal_url(@terminal)
#     end
#     assert_redirected_to terminals_url
#   end

#   test "should update terminal" do
#     @terminal2 = Terminal.create(:name=>"nksdjvfn",:landline=>"0123-1210446",)
#     @terminal = Terminal.create(:name=>"nksdrtjvn",:landline=>"0123-1015446")
#     @menuitem = @terminal.menu_items.create(name:"fegeg",price:1233,veg:true)
#     put terminal_url(@terminal.id), params: { terminal: { name:@terminal2.name,landline:@terminal.landline,
#       "menu_items_attributes"=>{"0"=>{"name"=>@menuitem.name, "price"=>@menuitem.price, "veg"=>"1", "_destroy"=>"false", 
#       "id"=>@menuitem.id}}}}
#     assert_equal @terminal2.name ,@terminal.name
#   end

#   test "should successfully import csv" do
#     csv_rows = <<-eos
# name,price,veg
# beer,224,true
# Name3,324,true
# eos
#     file = Tempfile.new('new_users.csv')
#     file.write(csv_rows)
#     file.rewind
#     @terminal = Terminal.create(name:"kjnf",landline:"0125-1563156")
#     assert_difference "MenuItem.count", 2 do
#       post import_terminal_path(@terminal.id), :file => Rack::Test::UploadedFile.new(file, 'text/csv')
#     end
#     assert_redirected_to terminal_path
#     assert_equal "all menu items added", flash[:success]
#   end

#   test "should gives invalid csv records" do
#     csv_rows = <<-eos
# name,price,veg
# beer,-44,true
# Name3,-78,true
# eos
#     file = Tempfile.new('new_users.csv')
#     file.write(csv_rows)
#     file.rewind
#     @terminal = Terminal.create(name:"kjnf",landline:"0125-1563156")
#     assert_difference "MenuItem.count", 0 do
#       post import_terminal_path(@terminal.id), :file => Rack::Test::UploadedFile.new(file, 'text/csv')
#     end
#     assert_equal "You have invalid some records.Correct it and upload again.", flash[:alert]
#   end

#   test "should give error for invalid csv file" do
#     csv_rows = <<-eos
# name,price,veg,dsff
# beer,-44,true
# Name3,-78,true
# eos
#     file = Tempfile.new('new_users.csv')
#     file.write(csv_rows)
#     file.rewind
#     @terminal = Terminal.create(name:"kjnf",landline:"0125-1563156")
#     assert_difference "MenuItem.count", 0 do
#       post import_terminal_path(@terminal.id), :file => Rack::Test::UploadedFile.new(file, 'text/csv')
#     end
#     assert_equal "You have invlaid csv please upload csv with valid headers.", flash[:error]
#   end


  def sign_in_admin
    admin = @company.employees.find_by(role: "company_admin")
    admin.confirm
    sign_in admin
  end

end
