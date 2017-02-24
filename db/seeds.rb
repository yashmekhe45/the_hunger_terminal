# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



company1 = Company.find_or_initialize_by(name: "xoriant", landline: "0235-1923222")
company1.employees.build(name: 'Padmaja Huddar', mobile_number: "+919999999989", email: "padmaja1@xoriant.com",
                          is_active: true, role: "company_admin",password: "padmaja123")
company1.build_address(house_no: "67", locality: "kharadi", pincode: 416417, city: "Benglore", state: "karnataka")
company1.save!


company1.employees.find_or_create_by(email: "stan@xoriant.com", name: "Stan",mobile_number: "+917222222222",is_active:true,role: "employee") do |user|
  user.password = "password"
  user.confirmed_at = Time.now
end
company1.employees.find_or_create_by(name: 'Kushal Kale', mobile_number: "+919999999979", email: "kushal@xoriant.com", is_active: true) do |user|
#                           is_active: true, role: "employee") do |user|
  user.password = "password"
  user.confirmed_at = Time.now
end
company1.employees.find_or_create_by(name: 'Amit Anvekar', mobile_number: "+919999999969", email:  "amit@xoriant.com", is_active: true) do |user|
#                           is_active: true, role: "employee") do |user|
  user.password = "password"
  user.confirmed_at = Time.now
end
# company1.employees.find_or_create_by(name: 'Kushal Kale', mobile_number: "+919999999979", email: "kushal@xoriant.com",
#                           is_active: true, role: "employee",password: "kushal23")
# company1.employees.find_or_create_by(name: 'Amit Anvekar', mobile_number: "+919999999969", email:  "amit@xoriant.com",
#                           is_active: true, role: "employee",password: "shubham123")
# company1.employees.find_or_create_by(name: 'Mrunal Selokar', mobile_number: "+919999999959", email: "padmaja@xoriant.com",
#                           is_active: true, role: "employee",password: "mrunal123")



company2 = Company.find_or_initialize_by(name: "twitter", landline: "0233-1923222")
company2.employees.build(name: 'Aarya', mobile_number: "+918989999999", email: "aarya@twitter.com",
                          is_active: true, role: "company_admin",password: "shivprasad123")
company2.build_address(house_no: "67", locality: "Hadapsar", pincode: 416417, city: "Shimla", state: "HP")
company2.save!
company2.employees.find_or_create_by(name: 'Shubham Yerawar', mobile_number: "+918789999999", email: "shubhamy@twitter.com",
                           is_active: true, role: "employee") do |user|
  user.password = "password"
  user.confirmed_at = Time.now
end
company2.employees.find_or_create_by(name: 'Namrata Tirthkar', mobile_number: "+918689999999", email: "namrata@twitter.com",
                           is_active: true, role: "employee") do |user|
  user.password = "password"
  user.confirmed_at = Time.now
end


company2.employees.find_or_create_by(name: 'Nisha Kasar', mobile_number: "+918589999999", email: "nisha@twitter.com",
                          is_active: true, role: "employee") do |user|
  user.password = "password"
  user.confirmed_at = Time.now
end

company2.employees.find_or_create_by(name: 'Nisha patil', mobile_number: "+918689999999", email: "nishap@twitter.com",
                          is_active: true, role: "employee") do |user|
  user.password = "password"
  user.confirmed_at = Time.now
end

company2.employees.find_or_create_by(name: 'umesh Tirthkar', mobile_number: "+918089999999", email: "umesh@twitter.com",
                           is_active: true, role: "employee") do |user|
  user.password = "password"
  user.confirmed_at = Time.now
end
# company2.employees.find_or_create_by(name: 'Shubham Yerawar', mobile_number: "+918789999999", email: "shubhamy@twitter.com",
#                           is_active: true, role: "employee",password: "shubham123")
# company2.employees.find_or_create_by(name: 'Namrata Tirthkar', mobile_number: "+918689999999", email: "namrata@twitter.com",
#                           is_active: true, role: "employee",password: "namrata123")
# company2.employees.find_or_create_by(name: 'Nisha Kasar', mobile_number: "+918589999999", email: "nisha@twitter.com",
#                           is_active: true, role: "employee",password: "nisha123")

# company3 = Company.find_or_initialize_by(name: "seagate", landline: "0234-1923222")
# company3.employees.build(name: 'sushant mane', mobile_number: "+919999999999", email: "sushant@seagate.com",
#                           is_active: true, role: "company_admin",password: "sushant123")
# company3.build_address(house_no: "67", locality: "Hadapsar", pincode: 416417, city: "Shimla", state: "HP")
# company3.save!

# company3.employees.find_or_create_by(name: 'Shubham pagarwar', mobile_number: "+919999999991", email: "shubhamy@seagate.com",
#                           is_active: true, role: "employee",password: "shubham123")
# company3.employees.find_or_create_by(name: 'Shital Gaikwad', mobile_number: "+919999999991", email:  "shital@seagate.com",
#                           is_active: true, role: "employee",password: "shital123")
# company3.employees.find_or_create_by(name: 'Snehal Bhosale', mobile_number: "+919999999992", email: "snehal@seagate.com",
#                           is_active: true, role: "employee",password: "snehal123")







