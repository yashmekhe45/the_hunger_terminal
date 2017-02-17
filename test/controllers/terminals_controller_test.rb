require "test_helper"

class TerminalsControllerTest < ActionDispatch::IntegrationTest
  
  setup do
    @terminal = Terminal.new(:name=>"havb",:landline=>"092-12365484")
    @terminal.save
  end

  test "should get index" do
    get terminals_path
    assert_response 200
  end

  test "should get new" do
    get new_terminal_path
    assert_response 200
  end

  test "should show terminal" do
    get terminal_path(@terminal)
    assert_response 200
  end

  test "should get edit" do
    get edit_terminal_path(@terminal)
    assert_response 200
  end

  test "should create terminal" do
    @terminal = Terminal.new(:name=>"nksdjvn",:landline=>"0123-1215446")
    assert_difference('Terminal.count',1) do
      post terminals_path, params: { terminal: { name: @terminal.name, landline: @terminal.landline } }
    end
  end

  test "should destroy terminal" do
    assert_difference('Terminal.count', -1) do
      delete terminal_url(@terminal)
    end
    assert_redirected_to terminals_url
  end

  test "should update terminal" do
    @terminal2 = Terminal.create(:name=>"nksdjvfn",:landline=>"0123-1210446",)
    @terminal = Terminal.create(:name=>"nksdrtjvn",:landline=>"0123-1015446")
    @menuitem = MenuItem.create(name:"fegeg",price:1233,veg:true)
    put terminal_url(@terminal), params: { terminal: { name:@terminal2.name,landline:@terminal.landline,
      "menu_items_attributes"=>{"0"=>{"name"=>@menuitem.name, "price"=>@menuitem.price, "veg"=>"1", "_destroy"=>"false", 
      "id"=>@menuitem.id}}}}
    assert_equal @terminal2.name ,@terminal.name
  end
end
