require 'rails_helper'

RSpec.describe Api::V1::SignInController, type: :controller do

	before do
		@test_user = FactoryGirl.create(:user)
	end

	it "Should not Sign in for incorrect email and password" do
		post :authenticate, params: {user:{email: "yes@gmail.com", password: "pass1$"}}
		expect(response.status).to eq 404
	end

	it "Should not Sign in for correct email and incorrect password" do
		post :authenticate, params: {user:{email: @test_user.email, password: "pass1$"}}
		expect(response.status).to eq 404
	end

	it "Should not Sign in for incorrect email and correct password" do
		post :authenticate, params: {user:{email: "yes@gmail.com", password: @test_user.password}}
		expect(response.status).to eq 404
	end

	it "Should Sign in for correct email and password" do
		post :authenticate, params: {user:{email: @test_user.email, password: @test_user.password}}
		expect(response.status).to eq 200
	end

end
