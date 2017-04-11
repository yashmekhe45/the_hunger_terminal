desc "This task sends reminder to users for placing order"

task :place_order_reminder => :environment do
  puts "Sending out email reminders for placing order."
  c = Company.find_by(name: "Dummy software")
  Order.send_reminders(c)
  puts "Emails sent!"
end