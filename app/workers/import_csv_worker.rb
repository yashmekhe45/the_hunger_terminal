require 'csv'
class ImportCsvWorker 
  include Sidekiq::Worker

  def perform(company_id, terminal_id, menu_items)
    @company = Company.find company_id 
    @terminal = @company.terminals.find terminal_id
    CSV.parse(menu_items,headers: true) do |row|
      next if row.to_a == ["name","price","veg","active_days","description"]
      @menu_item = @terminal.menu_items.build(row.to_h) 
      unless @menu_item.save 
        CSV.open(invalid_records_csv="public/#{@terminal.name}-invalid_records-#{Date.today}.csv", "a+") do |csv|
          row << @menu_item.errors.messages.to_a
          csv << row
        end
        @menu_item_errors = @menu_item
      end
      unless @menu_item_errors.nil?
        return invalid_records_csv
      end  
    end
  end
end
