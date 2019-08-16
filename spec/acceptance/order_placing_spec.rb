require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Order' do

	post '/api/terminals/:terminal_id/placing_orders' do

		let(:raw_post) { params.to_json }
		header "Content-Type", "application/json"
		header "Accept", "application/vnd.hunger-terminal.com; version=1"

		parameter :terminal_id, scope: :menu_item, with_example: true
		parameter :data, scope: :cart, with_example: true
		parameter :terminal_id, scope: :cart, with_example: true

		before do
			@test_company = FactoryGirl.create(:company)
			@test_terminal = FactoryGirl.create(:terminal, company_id: @test_company.id)
			@test_menu_item = FactoryGirl.create(:menu_item, terminal_id: @test_terminal.id) 
			@test_user = FactoryGirl.create(:user, company_id: @test_company.id)
			@auth_token = auth_token_for_user(@test_user)
			header "Authorization", @auth_token	
		end

		context "200" do
			let!(:terminal_id) { @test_terminal.id }
			let!(:data) { {"#{@test_menu_item.id}" => 2} }
	
			example 'Correct Authorization header' do
				do_request
				expect(headers['Authorization']).to eq(@auth_token)
			end

			let!(:terminal_id) { @test_terminal.id }
			let!(:data) { {"#{@test_menu_item.id}" => 2} }

			example 'Correct Accept header' do
				do_request
				expect(headers['Accept']).to eq "application/vnd.hunger-terminal.com; version=1"
			end

			let!(:terminal_id) { @test_terminal.id }
			let!(:data) { {"#{@test_menu_item.id}" => 2} }

			example 'Correct Response status' do
				do_request
				expect(status).to eq(200)
			end
		end

		context "401" do
			let!(:terminal_id) { @test_terminal.id }
			let!(:data) { {"#{@test_menu_item.id}" => 2} }
	
			example 'Incorrect Authorization header' do
				header "Authorization", @auth_token + 'a'
				do_request
				expect(status).to eq(401)
			end

			let!(:terminal_id) { @test_terminal.id + 1 }
			let!(:data) { {"#{@test_menu_item.id}" => 2} }

			example 'Incorrect request' do
				do_request
				expect(status).to eq(401)
			end

			let!(:terminal_id) { @test_terminal.id + 1 }
			let!(:data) { {"#{@test_menu_item.id}" => 2} }

			example 'failure message on failure' do
				do_request
				data = JSON.parse(response_body)
				expect(data["message"]).to eq "Invalid details provided!"
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
