desc "This task sends reminder to users for placing order"

task :place_order_reminder => :environment do
  # this is hardcoded because for now multitenancy is not there and we have to run rake task only for Josh Software... It will be modified afterwards.
  if company = Company.find_by(name: "Josh Software")
    puts "Sending out email reminders for placing order."
    company.send_reminders
    puts "Emails sent!"
  else
    puts "not a vaild company"
    exit 1
  end
end