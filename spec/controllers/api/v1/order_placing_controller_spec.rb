require 'rails_helper'
require_relative '../../../helpers/api/v1/AuthenticationHelper.rb'

RSpec.describe Api::V1::OrderPlacingController, type: :controller do
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
		post :order_bill, params: {terminal_id: @test_terminal.id, cart:{ terminal_id: @test_terminal.id, data: {"#{@test_menu_item.id}" => 2} }}
		expect(request.headers['Authorization']).to eq @auth_token
	end

	it "must return correct Accept header on success" do
		post :order_bill, params: {terminal_id: @test_terminal.id, cart:{ terminal_id: @test_terminal.id, data: {"#{@test_menu_item.id}" => 2} }}
		expect(request.headers['Accept']).to eq "application/vnd.hunger-terminal.com; version=1"
	end

	it "must return status 200 on success" do
		post :order_bill, params: {terminal_id: @test_terminal.id, cart:{ terminal_id: @test_terminal.id, data: {"#{@test_menu_item.id}" => 2} }}
		expect(response.status).to eq 200
	end

	it "must return status 401 on invalid Authorization token" do
		request.headers['Authorization'] = "#{@auth_token + 'a'}"
		post :order_bill, params: {terminal_id: @test_terminal.id, cart:{ terminal_id: @test_terminal.id, data: {"#{@test_menu_item.id}" => 2} }}
		expect(response.status).to eq 401
	end

	it "must return status 401 on failure" do
		post :order_bill, params: {terminal_id: @test_terminal.id + 1, cart:{ terminal_id: @test_terminal.id + 1, data: {"#{@test_menu_item.id}" => 2} }}
		expect(response.status).to eq 401
	end

	it "must return failure message on failure" do
		post :order_bill, params: {terminal_id: @test_terminal.id + 1, cart:{ terminal_id: @test_terminal.id + 1, data: {"#{@test_menu_item.id}" => 2} }}
		data = JSON.parse(response.body) 
		expect(data["message"]).to eq "Invalid details provided!"
	end

end