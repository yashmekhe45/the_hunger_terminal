desc "This task sends reminder to users for placing order"

task :place_order_reminder => :environment do
  puts "Sending out email reminders for placing order."
  Order.send_reminders
  puts "Emails sent!"
end