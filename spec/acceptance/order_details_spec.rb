require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Order Details' do

	post '/api/orders/myOrders' do

		let(:raw_post) { params.to_json }
		header "Content-Type", "application/json"
		header "Accept", "application/vnd.hunger-terminal.com; version=1"

		parameter :from, scope: :duration, with_example: true
		parameter :to, scope: :duration, with_example: true

		before do
			@test_company = FactoryGirl.create(:company)
			@test_terminal = FactoryGirl.create(:terminal, company_id: @test_company.id)
			@test_menu_item = FactoryGirl.create(:menu_item, terminal_id: @test_terminal.id) 
			@test_user = FactoryGirl.create(:user, company_id: @test_company.id)
			@auth_token = auth_token_for_user(@test_user)
			header "Authorization", @auth_token	
		end

		context "200" do
			let!(:from) { "2019-08-01" }
			let!(:to) { "2019-08-13" }
	
			example 'Correct Authorization header' do
				do_request
				expect(headers['Authorization']).to eq(@auth_token)
				expect(status).to eq(200)
			end

			example 'Correct Accept header' do
				do_request
				expect(headers['Accept']).to eq "application/vnd.hunger-terminal.com; version=1"
				expect(status).to eq(200)
			end

			example 'Correct Response status' do
				do_request
				expect(status).to eq(200)
			end

			example 'Record not found message if no record exists when request is valid' do
				do_request
				data = JSON.parse(response_body)
				expect(data["message"]).to eq "No order is present for this period!"
				expect(status).to eq(200)
			end

		end

		context "401" do
			let!(:from) { "2019-08-01" }
			let!(:to) { "2019-08-13" }
	
			example 'Incorrect Authorization header' do
				header "Authorization", @auth_token + 'a'
				do_request
				expect(status).to eq(401)
			end

			let!(:from) { "2019-08-14" }
			let!(:to) { "2019-08-13" }

			example 'Incorrect if From date is greater than To date' do
				do_request
				expect(status).to eq(401)
			end

			example 'error message when From date is greater than To date' do
				do_request
				data = JSON.parse(response_body)
				expect(data["error"]).to eq "From date must be less than To date!"
				expect(status).to eq(401)
			end
		end

	end

	private

	def auth_token_for_user(user)
	  data = signin(user)
	  if data == 0
	    return nil
	  else
	    return data
	  end
	end

	def signin(user)
	  @user_validate = User.find_by( email: user.email )
	  if !(User.find_by( email: user.email))
	    return 0
	  end
	  if @user_validate.valid_password?(user.password)
	    return generate_auth_token_for_users(@user_validate)
	  else
	    return 0
	  end
	end

	def generate_auth_token_for_users(user)
	  payload = { user_id: user.id } 
	  exp = 1.hours.from_now
	  payload[:exp] = exp.to_i
	  JWT.encode(payload, "JOSH", "HS256")
	end

end
