namespace :order do

  desc 'This task deletes such order records which has order_date less than last 3 months'
  task delete_old: :environment do
    today = Date.today
    next unless today == today.end_of_month
    old_orders = Order.where("date < ?", today.beginning_of_month - 3.months)
    deleted_orders = old_orders.destroy_all
    puts "#{deleted_orders.count} Orders Deleted Successfully"
  end

end
