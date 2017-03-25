
company1 = Company.find_or_initialize_by(name: "Dummy software", landline: "0235192322")
u = company1.employees.find_or_initialize_by(name: 'Tejaswini Gambhire', mobile_number: "8830224850", email: "tejaswini@test.com",
  role: "company_admin", is_active: true)
u.password = "tejaswini"
u.confirmed_at = Time.now if !u.confirmed?
u.save!
company1.build_address(house_no: "67", locality: "kharadi", pincode: 416417, city: "Benglore", state: "karnataka")
company1.save!

10.times do |i|
  u = company1.employees.find_or_create_by(name: "test#{i}", email: "test#{i}@test.com", mobile_number: "987654456#{i}", is_active: true, role: "employee")
  u.password = "test@#{i}"
  u.confirmed_at = Time.now if !u.confirmed?
  u.save!
end
