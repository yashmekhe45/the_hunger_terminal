require 'rails_helper'
require_relative '../../../helpers/api/v1/AuthenticationHelper.rb'

RSpec.describe Api::V1::MenuListingController, type: :controller do
	include AuthenticationHelper

	before do
		@test_company = FactoryGirl.create(:company)
		@test_terminal = FactoryGirl.create(:terminal, company_id: @test_company.id)
		@test_menu_item = FactoryGirl.create(:menu_item, terminal_id: @test_terminal.id) 
		@test_user = FactoryGirl.create(:user, company_id: @test_company.id)
		@auth_token = auth_token_for_user(@test_user)
		request.headers['Content-Type'] = "application/json"
		request.headers['Accept'] = "application/vnd.hunger-terminal.com; version=1"
		request.headers['Authorization'] = "#{@auth_token}"
	end

	it "must return valid jwt token on success" do
		get :load_menu, params: { terminal_id: @test_terminal.id }
		expect(request.headers['Authorization']).to eq @auth_token
	end

	it "must return correct Accept header on success" do
		get :load_menu, params: { terminal_id: @test_terminal.id }
		expect(request.headers['Accept']).to eq "application/vnd.hunger-terminal.com; version=1"
	end

	it "must return status 200 on success" do
		get :load_menu, params: { terminal_id: @test_terminal.id }
		expect(response.status).to eq 200
	end

	it "must return status 401 on incorrect Authorization token" do
		request.headers['Authorization'] = "#{@auth_token + 'a'}"
		get :load_menu, params: { terminal_id: @test_terminal.id }
		expect(response.status).to eq 401
	end

	it "must return output in correct format" do
		get :load_menu, params: { terminal_id: @test_terminal.id }
		data = JSON.parse(response.body)
		data_format = data["data"][0]
		expect(response.status).to eq 200
		expect(data_format["id"].to_i).to eq @test_menu_item.id
		expect(data_format["type"]).to eq "menu"
		expect(data_format["attributes"]["id"]).to eq @test_menu_item.id
		expect(data_format["attributes"]["name"]).to eq @test_menu_item.name
		expect(data_format["attributes"]["terminal_id"]).to eq @test_menu_item.terminal_id
		expect(data_format["attributes"]["available"]).to eq @test_menu_item.available
		expect(data_format["attributes"]["veg"]).to eq @test_menu_item.veg
		expect(data_format["attributes"]["price"]).to eq @test_menu_item.price
		expect(data_format["attributes"]["description"]).to eq @test_menu_item.description
		expect(data_format["attributes"]["active_days"]).to eq @test_menu_item.active_days
		expect(data_format["attributes"]["review"]).to eq @test_menu_item["review"]
		expect(data_format["attributes"]["terminal_rating"]).to eq @test_terminal["review"]
	end

end
