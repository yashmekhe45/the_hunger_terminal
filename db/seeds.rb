
company1 = Company.find_or_initialize_by(name: "Dummy software", landline: "0235-1923222")
company1.employees.find_or_initialize_by(name: 'Tejaswini Gambhire', mobile_number: "+918830223850", email: "tejaswini@joshsoftware.com",
                      password: "tejaswini",confirmed_at: Time.now)
company1.build_address(house_no: "67", locality: "kharadi", pincode: 416417, city: "Benglore", state: "karnataka")
company1.save!


company1.employees.find_or_create_by(email: "kirand@dummysoftware.com", name: "Kiran Deshmukh",mobile_number: "+919421215727",is_active:true,role: "employee") do |user|
  user.password = "kiran123"
  user.confirmed_at = Time.now
end
company1.employees.find_or_create_by(name: 'Akshay Kakade', mobile_number: "+919096089881",
 email: "akshay@dummysoftware.com", is_active: true, role: "employee") do |user|                
  user.password = "akshay123"
  user.confirmed_at = Time.now
end
company1.employees.find_or_create_by(name: 'Shivam Singh', mobile_number: "+917746991695",
 email:  "shivam@dummysoftware.com", is_active: true, role: "employee") do |user|
  user.password = "shivam123" 
  user.confirmed_at = Time.now 
end










