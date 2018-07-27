

desc "This task sends reminder to users for placing order"
task :place_order_reminder => :environment do
  # this is hardcoded because for now multitenancy is not there and we have to run rake task only for Josh Software... It will be modified afterwards.

  OneClickOrder.nullify_tokens # Nullify all the previous tokens

  if company = Company.find_by(name: "Josh Software")
    puts "Sending out email reminders for placing order."
    company.send_reminders
    puts "Emails sent!"
  else
    puts "not a vaild company"
    exit 1
  end
end


desc "This task will delete all the OneClickOrder records"
task :nullify_oneclickorder_tokens => :environment do
  OneClickOrder.nullify_tokens
end

desc "This task will reset the end ordering time"
task reset_end_ordering_at: :environment do
  Company.update(end_ordering_at: "12:30 PM")
end
