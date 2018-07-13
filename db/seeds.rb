comp = Company.find_or_initialize_by(name: 'CompanyRaj', landline: '01234567890',email: 'raj@company.com',start_ordering_at: Time.zone.parse('12 AM'),end_ordering_at: Time.zone.parse('11 PM'),review_ordering_at: Time.zone.parse('11:30 PM'),subsidy: 50)
comp.build_address(house_no: '67', locality: 'kharadi', pincode: 416417, city: 'Benglore', state: 'karnataka')

admin = comp.employees.find_or_initialize_by(name: 'Raj Kamal Lashkari', mobile_number: '1234567890', email: 'admin@comp.com', role: 'company_admin', is_active: true,password: 'admincomp')
admin.confirmed_at = Time.now if !admin.confirmed?
admin.save!

comp.save!

for i in 1..5
  emp = comp.employees.find_or_create_by(name: "Emp#{i}Comp1", email: "emp#{i}@comp.com", mobile_number: "123456789#{i}", is_active: true, role: 'employee')
  emp.password = 'empcomp'
  emp.confirmed_at = Time.now if !emp.confirmed?
  emp.save!
end

comp2 = Company.find_or_initialize_by(name: 'Company2', landline: '01234567894',email: 'company@two.com',start_ordering_at: Time.zone.parse('12 AM'),end_ordering_at: Time.zone.parse('11 PM'),review_ordering_at: Time.zone.parse('11:30 PM'),subsidy: 50)
comp2.build_address(house_no: '67', locality: 'kharadi', pincode: 416417, city: 'Benglore', state: 'karnataka')

admin2 = comp2.employees.find_or_initialize_by(name: 'Raj Kamal Lashkari', mobile_number: '1234567895', email: 'admin@comp2.com', role: 'company_admin', is_active: true,password: 'admincomp2')
admin2.confirmed_at = Time.now if !admin2.confirmed?
admin2.save!

comp2.save!


emp2 = comp2.employees.find_or_create_by(name: 'emp2', email: 'emp@comp2.com', mobile_number: '1234567899', is_active: true, role: 'employee')
emp2.password = 'empcomp2'
emp2.confirmed_at = Time.now if !emp2.confirmed?
emp2.save!

terminal_1 =Terminal.find_or_create_by(name:'Terminal One',  landline:'01234567891',email:'ter@one.com',  min_order_amount: 100, active: true, company_id: comp.id)
terminal_2 =Terminal.find_or_create_by(name:'Terminal Two',  landline:'01234567892',email:'ter@two.com',  min_order_amount: 200, active: true, company_id: comp.id)
terminal_3 =Terminal.find_or_create_by(name:'Terminal Three',landline:'01234567893',email:'ter@three.com',min_order_amount: 300, active: true, company_id: comp.id)
terminal_4 =Terminal.find_or_create_by(name:'Terminal Four', landline:'01234567894',email:'ter@four.com', min_order_amount: 400, active: true, company_id: comp.id)
terminal_5 =Terminal.find_or_create_by(name:'Terminal Five', landline:'01234567895',email:'ter@five.com', min_order_amount: 500, active: true, company_id: comp.id)
terminal_6 =Terminal.find_or_create_by(name:'Terminal six',  landline:'01234567891',email:'ter@one.com',  min_order_amount: 100, active: true, company_id: comp2.id)
terminal_7 =Terminal.find_or_create_by(name:'Terminal seven',landline:'01234567892',email:'ter@two.com',  min_order_amount: 200, active: true, company_id: comp2.id)
terminal_8 =Terminal.find_or_create_by(name:'Terminal eight',landline:'01234567893',email:'ter@three.com',min_order_amount: 300, active: true, company_id: comp2.id)
terminal_9 =Terminal.find_or_create_by(name:'Terminal nine', landline:'01234567894',email:'ter@four.com', min_order_amount: 400, active: true, company_id: comp2.id)
terminal_10=Terminal.find_or_create_by(name:'Terminal ten',  landline:'01234567895',email:'ter@five.com', min_order_amount: 500, active: true, company_id: comp2.id)

menu = [
  { active_days: '{1,2,3,4,5,6}',available: true,price:40, veg:true, name:'veg one'},
    { active_days: '{1,2,3,4,5,6}',available: true,price:90, veg:true, name:'veg two'},
    { active_days: '{1,2,3,4,5,6}',available: true,price:80, veg:true, name:'veg three'},
    { active_days: '{1,2,3,4,5,6}',available: true,price:60, veg:false,name:'non-veg one'},
    { active_days: '{1,2,3,4,5,6}',available: true,price:100,veg:false,name:'non-veg two'},
    { active_days: '{1,2,3,4,5,6}',available: true,price:100,veg:false,name:'non-veg three'},
    { active_days: '{1,2,3,4,5,6}',available: true,price:130,veg:true, name:'veg one'},
  { active_days: '{1,2,3,4,5,6}',available: true,price:110,veg:true, name:'non-veg one',}]

def add_menues(terminal,menu_items)
   menu_items.each do |m|
     terminal.menu_items.find_or_create_by(m)
   end
end

add_menues(terminal_1,menu)
add_menues(terminal_2,menu)
add_menues(terminal_3,menu)
add_menues(terminal_4,menu)
add_menues(terminal_5,menu)
add_menues(terminal_6,menu)
add_menues(terminal_7,menu)
add_menues(terminal_8,menu)
add_menues(terminal_9,menu)
add_menues(terminal_10,menu)