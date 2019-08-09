require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Menu' do

	get '/api/terminals/:terminal_id/menu_items' do

		header "Content-Type", "application/json"
		header "Accept", "application/vnd.hunger-terminal.com; version=1"

		parameter :terminal_id, scope: :menu_item, with_example: true

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
	
			example 'Correct Authorization header' do
				do_request
				expect(status).to eq(200)
			end

			let!(:terminal_id) { @test_terminal.id }

			example 'Correct Accept header' do
				do_request
				expect(headers['Accept']).to eq "application/vnd.hunger-terminal.com; version=1"
			end

			let!(:terminal_id) { @test_terminal.id }

			example 'Response in correct format' do
				do_request
				data = JSON.parse(response_body)
				data_format = data["data"][0]
				expect(status).to eq(200)
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
