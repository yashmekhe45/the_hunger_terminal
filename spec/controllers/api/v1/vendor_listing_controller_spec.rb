require 'rails_helper'
require_relative '../../../helpers/api/v1/AuthenticationHelper.rb'

RSpec.describe Api::V1::VendorListingController, type: :controller do
	include AuthenticationHelper

	before do
		@test_company = FactoryGirl.create(:company)
		@test_terminal = FactoryGirl.create(:terminal, company_id: @test_company.id) 
		@test_user = FactoryGirl.create(:user, company_id: @test_company.id)
		@auth_token = auth_token_for_user(@test_user)
		request.headers['Content-Type'] = "application/json"
		request.headers['Accept'] = "application/vnd.hunger-terminal.com; version=1"
		request.headers['Authorization'] = "#{@auth_token}"	
	end

	it "must return valid jwt token on success" do
		get :load_terminals
		expect(request.headers['Authorization']).to eq @auth_token
	end

	it "must return correct Accept header on success" do
		get :load_terminals
		expect(request.headers['Accept']).to eq "application/vnd.hunger-terminal.com; version=1"
	end

	it "must return status 200 on success" do
		get :load_terminals
		expect(response.status).to eq 200
	end

	it "must return status 401 on incorrect Authorization token" do
		request.headers['Authorization'] = "#{@auth_token + 'a'}"
		get :load_terminals
		expect(response.status).to eq 401
	end

	it "must have output in correct format" do
		get :load_terminals
		data = JSON.parse(response.body)
		data_format = data["data"][0]
		expect(response.status).to eq 200
		expect(data_format["id"].to_i).to eq @test_terminal.id
		expect(data_format["type"]).to eq "terminal"
		expect(data_format["attributes"]["name"]).to eq @test_terminal["name"]
		expect(data_format["attributes"]["active"]).to eq @test_terminal["active"]
		expect(data_format["attributes"]["min_order_amount"]).to eq @test_terminal["min_order_amount"]
		expect(data_format["attributes"]["tax"]).to eq @test_terminal["tax"]
		expect(data_format["attributes"]["review"]).to eq @test_terminal["review"]
		expect(data_format["attributes"]["end_ordering_at"]).to eq @test_company.end_ordering_at.strftime('%H:%M:%S')
	end

end
