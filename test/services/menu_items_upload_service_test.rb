require 'test_helper'

class MenuItemsUploadServiceTest < ActiveSupport::TestCase

  before :each do
    @terminal = create(:terminal)
    @company = @terminal.company
  end

  test 'it uploads valid records' do

    file_name = File.new(Rails.root.join("test/fixtures/files/menu.csv"))
    csv_file = Rack::Test::UploadedFile.new(file_name, 'text/csv')
    params = {
      file: csv_file,
      terminal_id: @terminal.id,
      company_id: @company.id
    }
    check_result(params)
  end

  test "it should not upload invalid header records" do
    file_name = File.new(Rails.root.join("test/fixtures/files/invalid_headers_menu.csv"))
    csv_file = Rack::Test::UploadedFile.new(file_name, 'text/csv')
    params = {
      file: csv_file,
      terminal_id: @terminal.id,
      company_id: @company.id
    }
    check_result(params)
  end

  #For now, valid file type is CSV
  test "it should not upload file having invalid type" do
    file_name = File.new(Rails.root.join("test/fixtures/files/menu.txt"))
    text_file = Rack::Test::UploadedFile.new(file_name, 'text')
    params = {
      file: text_file,
      terminal_id: @terminal.id,
      company_id: @company.id
    }
    check_result(params) 
  end

  def check_result(params)
    upload = MenuItemsUploadService.new(params).upload_records
    assert upload
  end

end