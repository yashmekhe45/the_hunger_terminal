require 'rails_helper'
require_relative '../../../helpers/api/v1/AuthenticationHelper.rb'

RSpec.describe Api::V1::OrderDetailsController, type: :controller do
	include AuthenticationHelper

	before do
		@test_company = FactoryGirl.create(:company)
		@test_terminal = FactoryGirl.create(:terminal, company_id: @test_company.id)
		@test_menu_item = FactoryGirl.create(:menu_item, terminal_id: @test_terminal.id) 
		@test_user = FactoryGirl.create(:user, company_id: @test_company.id)
		@test_order = FactoryGirl.create(:order, user_id: @test_user.id, company_id: @test_company.id, terminal_id: @test_terminal.id, status: "confirmed", discount: @test_company.subsidy)
		@test_order_detail = FactoryGirl.create(:order_detail, order_id: @test_order.id, menu_item_name: @test_menu_item.name, quantity: 1)
		@auth_token = auth_token_for_user(@test_user)
		request.headers['Content-Type'] = "application/json"
		request.headers['Accept'] = "application/vnd.hunger-terminal.com; version=1"
		request.headers['Authorization'] = "#{@auth_token}"
	end

	it "must return valid jwt token on success" do
		post :order_history, params: {duration:{ from: "2019-08-01", to: "2019-08-13" }}
		expect(request.headers['Authorization']).to eq @auth_token
	end

	it "must return correct Accept header on success" do
		post :order_history, params: {duration:{ from: "2019-08-01", to: "2019-08-13" }}
		expect(request.headers['Accept']).to eq "application/vnd.hunger-terminal.com; version=1"
	end

	it "must return status 200 on success" do
		post :order_history, params: {duration:{ from: "2019-08-01", to: "2019-08-13" }}
		expect(response.status).to eq 200
	end

	it "must return status 401 on invalid Authorization token" do
		request.headers['Authorization'] = "#{@auth_token + 'a'}"
		post :order_history, params: {duration:{ from: "2019-08-01", to: "2019-08-13" }}
		expect(response.status).to eq 401
	end

	it "must return no record found message if no record exists for given duration" do
		post :order_history, params: {duration:{ from: "2020-07-01", to: "2020-07-02" }}
		data = JSON.parse(response.body) 
		expect(data["message"]).to eq "No order is present for this period!"
		expect(response.status).to eq 200
	end

	it "must return error message if from date is greater than to date" do
		post :order_history, params: {duration:{ from: "2019-08-01", to: "2019-07-30" }}
		data = JSON.parse(response.body) 
		expect(data["error"]).to eq "From date must be less than To date!"
		expect(response.status).to eq 401
	end

end
