
company1 = Company.find_or_initialize_by(name: "Dummy software", landline: "0235192322",email: "dummysoftware@gmail.com")
company1.start_ordering_at = Time.zone.parse "12 AM"
company1.end_ordering_at = Time.zone.parse "11 AM"
company1.review_ordering_at = Time.zone.parse "11:30 AM"
company1.subsidy = 50
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

def add_menues(terminal,menu_items)
   menu_items.each do |m|
     terminal.menu_items.find_or_create_by(m)
   end
end


terminal1=Terminal.find_or_create_by(name:"Fassos",landline:"9823456123",email:"fassos@abc.com",min_order_amount: 500, active: true, company_id: company1.id)
terminal2=Terminal.find_or_create_by(name:"Dominos",landline:"9823456712",email:"dominos@abc.com",min_order_amount: 500, active: true, company_id: company1.id)
terminal3=Terminal.find_or_create_by(name:"Rolls Mania",email:"rollsmania@abc.com",landline:"9923561424",min_order_amount: 500, active: true, company_id: company1.id)
terminal4=Terminal.find_or_create_by(name:"Food Panda",landline:"9823752123",email:"foodpanda@abc.com",min_order_amount: 500, active: true, company_id: company1.id)
terminal5=Terminal.find_or_create_by(name:"Eatsome",landline:"9823456124",email:"eatsome@abc.com",min_order_amount: 500, active: true, company_id: company1.id) 

menu = [{name:"veg roll",price:40,veg:true,available: true, active_days: '{1,2,3,4,5,6}'},
  {name:"cheese pizza",price:90,veg:true,available: true, active_days: '{1,2,3,4,5,6}'},
  {name:"chicken roll",price:60,veg:false,available: true, active_days: '{1,2,3,4,5,6}'},
  {name:"manchurian",price:80,veg:true,available: true, active_days: '{1,2,3,4,5,6}'},
  {name:"biryani",price:100,veg:false,available: true, active_days: '{1,2,3,4,5,6}'},
  {name:"veg kolhapuri",price:130,veg:true,available: true, active_days: '{1,2,3,4,5,6}'},
  {name:"paneer tikka",price:110,veg:true,available: true, active_days: '{1,2,3,4,5,6}'},
  {name:"paneer tikka",price:110,veg:true,available: true, active_days: '{1,2,3,4,5,6}'},
  {name:"veg maratha",price:120,veg:true,available: true, active_days: '{1,2,3,4,5,6}'}]
add_menues(terminal1,menu)
add_menues(terminal2,menu)
add_menues(terminal3,menu)
add_menues(terminal4,menu)
add_menues(terminal5,menu)
