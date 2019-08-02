require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Sign in' do

	post '/api/sign_in' do

		let(:raw_post) { params.to_json }
	  header "Content-Type", "application/json"
	  header "Accept", "application/vnd.hunger-terminal.com; version=1"

	  parameter :email, scope: :user, with_example: true
	  parameter :password, scope: :user, with_example: true

	 	before do
			@test_user = FactoryGirl.create(:user)
		end

		context "404" do
			let!(:email) {@test_user.email + 'a'}
			let!(:password) {@test_user.password + 'a'}
			
		  example 'Incorrect email and password' do 
				do_request
				expect(status).to eq(404)
		  end

		  let!(:email) {@test_user.email + 'a'}
			let!(:password) {@test_user.password}

		  example 'Incorrect email and correct password' do
				do_request
				expect(status).to eq(404)
			end

			let!(:email) {@test_user.email}
			let!(:password) {@test_user.password + 'a'}

			example 'correct email and Incorrect password' do
				do_request
				expect(status).to eq(404)
			end
		end

		context "200" do
			let!(:email) {@test_user.email}
			let!(:password) {@test_user.password}

			example 'correct email and correct password' do
				do_request
				expect(status).to eq(200)
			end
		end

	end
end
