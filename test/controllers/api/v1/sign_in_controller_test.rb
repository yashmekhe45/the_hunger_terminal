require "test_helper"

describe Api::V1::SignInController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end
	before :each do
  	@user = create :user
	end

	test "Should not sign in user with incorrect email and password" do
		post :signin, params: {user: {email: "test@test.com", password: "tes@1"}}
    assert_equal 404, response.status
	end
	
	test "Should not sign in user with incorrect email and correct password" do
		post :signin, params: {user: {email: "test@test.com", password: @user.password}}
		assert_equal 404, response.status
	end

	test "Should not sign in user with correct email and incorrect password" do
		post :signin, params: {user: {email: @user.email, password: "tes@1"}}
		assert_equal 404, response.status
	end

	test "Should sign in user with correct email and password" do
		post :signin, params: {user: {email: @user.email, password: @user.password}}
		assert_equal 200, response.status
	end

end
