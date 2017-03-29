require 'csv'
class ImportCsvWorker 
  # include Sidekiq::Worker
  # sidekiq_options :queue => :default, :retry => false, :backtrace => true

  # # def perform(company_id, terminal_id, menu_items)
  # #   # invalid_records_csv = nil
  # #   # @menu_item_errors = nil
  # #   @company = Company.find company_id 
  # #   @terminal = @company.terminals.find terminal_id
  # #   CSV.parse(menu_items.to_s,headers: true) do |row|
  # #     next if row.to_a == ["name","price","veg","description","active_days"]
  # #     row["active_days"] = row["active_days"].split(',').map{|day| day.strip}
  # #     @menu_item = @terminal.menu_items.build(row.to_h)
  # #     @menu_item.save
  # #     # if !@menu_item.save 
  # #     #   CSV.open(invalid_records_csv="/home/project/Desktop/#{@terminal.name}-invalid_records-#{Date.today}.csv", "a+") do |csv|
  # #     #     row << @menu_item.errors.messages.to_a
  # #     #     csv << row
  # #     #   end
  # #     #   @menu_item_errors = @menu_item
  # #     # end      
  # #   end

  # #   # print '=============', @menu_item_errors
  # #   # if @menu_item_errors.nil?
  # #   #   print "in in action in a"
  # #   #   return nil
  # #   # else
  # #   #   print "i am in action b"
  # #   #   return invalid_records_csv.to_s
  # #   # end  
  # # end
end
