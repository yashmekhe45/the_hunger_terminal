require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Vendors' do

	get '/api/vendors' do

		header "Content-Type", "application/json"
		header "Accept", "application/vnd.hunger-terminal.com; version=1"

		before do
			@test_company = FactoryGirl.create(:company)
			@test_terminal = FactoryGirl.create(:terminal, company_id: @test_company.id)
			@test_user = FactoryGirl.create(:user, company_id: @test_company.id)
			@auth_token = auth_token_for_user(@test_user)
			header "Authorization", @auth_token	
		end

		context "200" do
	
			example 'Correct Authorization header' do
				do_request
				expect(status).to eq(200)
			end

			example 'Correct Accept header' do
				do_request
				expect(headers['Accept']).to eq "application/vnd.hunger-terminal.com; version=1"
			end

			example 'Response in correct format' do
				do_request
				data = JSON.parse(response_body)
				data_format = data["data"][0]
				expect(status).to eq(200)
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

		context "401" do

			example 'Incorrect Authorization header' do
				header "Authorization", @auth_token + 'a'
				do_request
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