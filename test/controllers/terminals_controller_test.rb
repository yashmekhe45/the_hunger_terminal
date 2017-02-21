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
    @menuitem = @terminal.menu_items.create(name:"fegeg",price:1233,veg:true)
    put terminal_url(@terminal.id), params: { terminal: { name:@terminal2.name,landline:@terminal.landline,
      "menu_items_attributes"=>{"0"=>{"name"=>@menuitem.name, "price"=>@menuitem.price, "veg"=>"1", "_destroy"=>"false", 
      "id"=>@menuitem.id}}}}
    assert_equal @terminal2.name ,@terminal.name
  end

  test "should successfully import csv" do
    csv_rows = <<-eos
name,price,veg
beer,224,true
Name3,324,true
eos
    file = Tempfile.new('new_users.csv')
    file.write(csv_rows)
    file.rewind
    @terminal = Terminal.create(name:"kjnf",landline:"0125-1563156")
    assert_difference "MenuItem.count", 2 do
      post import_terminal_path(@terminal.id), :file => Rack::Test::UploadedFile.new(file, 'text/csv')
    end
    assert_redirected_to terminal_path
    assert_equal "all menu items added", flash[:success]
  end

  test "should gives invalid csv records" do
    csv_rows = <<-eos
name,price,veg
beer,-44,true
Name3,-78,true
eos
    file = Tempfile.new('new_users.csv')
    file.write(csv_rows)
    file.rewind
    @terminal = Terminal.create(name:"kjnf",landline:"0125-1563156")
    assert_difference "MenuItem.count", 0 do
      post import_terminal_path(@terminal.id), :file => Rack::Test::UploadedFile.new(file, 'text/csv')
    end
    assert_equal "You have invalid some records.Correct it and upload again.", flash[:alert]
  end

  test "should give error for invalid csv file" do
    csv_rows = <<-eos
name,price,veg,dsff
beer,-44,true
Name3,-78,true
eos
    file = Tempfile.new('new_users.csv')
    file.write(csv_rows)
    file.rewind
    @terminal = Terminal.create(name:"kjnf",landline:"0125-1563156")
    assert_difference "MenuItem.count", 0 do
      post import_terminal_path(@terminal.id), :file => Rack::Test::UploadedFile.new(file, 'text/csv')
    end
    assert_equal "You have invlaid csv please upload csv with valid headers.", flash[:error]
  end
end
