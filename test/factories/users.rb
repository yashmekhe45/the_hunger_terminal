FactoryGirl.define do
  factory :user do
    name {Faker::Name.name}
    role "company_admin"
    email {Faker::Internet.email}
    mobile_number {"+919876543210"}
    is_active {true}
    encrypted_password {Faker::Internet.password}
    
  end
end
