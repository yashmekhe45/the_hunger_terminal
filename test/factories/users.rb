FactoryGirl.define do
  factory :user do |u|
    u.name {Faker::Name.name}
    u.role "company_admin"
    u.email {Faker::Internet.email}
    u.mobile_number {"+919876543210"}
    u.is_active {true}
    u.password {Faker::Internet.password}
    company
    
  end
end
