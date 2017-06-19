require "test_helper"

class CompaniesControllerTest  < ActionController::TestCase

  before :each do
    @company = create :company
    @user = create :user
    @user.update_attribute(:role, "employee")
  end

  # test "should show company" do
  #   company = build(:company)
  #   get company_url(company)
  #   assert_response :success    
  # end

  test " should get new company" do
    get :new
    assert_response :success
  end

  test "should create company" do 
    post :create, 
    params: 
      { company:
        { name: "dummy software", landline: "02472240728", 
         email: "info@dummysoftware.com", subsidy: 50, start_ordering_at: Time.parse("12 AM"),end_ordering_at: Time.parse("12:30 PM"),
         address_attributes:
          { house_no: "23A", pincode: 416415, locality:"Baner", city: "pune", state: "mh"}, 
          employees_attributes: 
          { "0" => {name: "kiran", email: "kiran@dummysoftware.com", mobile_number: "9898989898", password: "123456"} 
          } 
        } 
      }
    assert_response :redirect
   end

  test "should not create a company" do
    post :create,
      params: 
        {company:
          { name: "", landline: "",email: "", subsidy: "",start_ordering_at: "", end_ordering_at: "", review_ordering_at: "",
            address_attributes: 
            {
              address: {house_no: "", pincode: "", locality: "",city: "",state: ""}
            },
            employees_attributes:
            {
              "0" => {name: "", email: "",mobile_number: "",password: ""}
            }
          }
        }

    assert_response :success
  end

  
end