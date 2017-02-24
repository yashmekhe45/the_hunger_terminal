# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



company1 = Company.find_or_initialize_by(name: "Josh software", landline: "0235-1923222")
company1.employees.build(name: 'Tejaswini Gambhire', mobile_number: "+918830223850", email: "tejaswini@joshsoftware.com",
                          is_active: true, role: "company_admin",password: "tejaswini")
company1.build_address(house_no: "67", locality: "kharadi", pincode: 416417, city: "Benglore", state: "karnataka")
company1.save!


company1.employees.find_or_create_by(email: "kirand@joshsoftware.com", name: "Kiran Deshmukh",mobile_number: "+919421215727",is_active:true,role: "employee") do |user|
  user.password = "kiran123"
  user.confirmed_at = Time.now
end
company1.employees.find_or_create_by(name: 'Akshay Kakade', mobile_number: "+919096089881", email: "akshay@joshsoftware.com", is_active: true) do |user|
#                           is_active: true, role: "employee") do |user|
  user.password = "akshay123"
  user.confirmed_at = Time.now
end
company1.employees.find_or_create_by(name: 'Shivam Singh', mobile_number: "+917746991695", email:  "shivam@joshsoftware.com", is_active: true) do |user|
#                           is_active: true, role: "employee") do |user|
  user.password = "shivam123"
  user.confirmed_at = Time.now
end



# company2 = Company.find_or_initialize_by(name: "twitter", landline: "0233-1923222")
# company2.employees.build(name: 'Aarya', mobile_number: "+918989999999", email: "aarya@twitter.com",
#                           is_active: true, role: "company_admin",password: "shivprasad123")
# company2.build_address(house_no: "67", locality: "Hadapsar", pincode: 416417, city: "Shimla", state: "HP")
# company2.save!
# company2.employees.find_or_create_by(name: 'Shubham Yerawar', mobile_number: "+918789999999", email: "shubhamy@twitter.com",
#                            is_active: true, role: "employee") do |user|
#   user.password = "password"
#   user.confirmed_at = Time.now
# end
# company2.employees.find_or_create_by(name: 'Namrata Tirthkar', mobile_number: "+918689999999", email: "namrata@twitter.com",
#                            is_active: true, role: "employee") do |user|
#   user.password = "password"
#   user.confirmed_at = Time.now
# end


# company2.employees.find_or_create_by(name: 'Nisha Kasar', mobile_number: "+918589999999", email: "nisha@twitter.com",
#                           is_active: true, role: "employee") do |user|
#   user.password = "password"
#   user.confirmed_at = Time.now
# end

# company2.employees.find_or_create_by(name: 'Nisha patil', mobile_number: "+918689999999", email: "nishap@twitter.com",
#                           is_active: true, role: "employee") do |user|
#   user.password = "password"
#   user.confirmed_at = Time.now
# end

# company2.employees.find_or_create_by(name: 'umesh Tirthkar', mobile_number: "+918089999999", email: "umesh@twitter.com",
#                            is_active: true, role: "employee") do |user|
#   user.password = "password"
#   user.confirmed_at = Time.now
# end








