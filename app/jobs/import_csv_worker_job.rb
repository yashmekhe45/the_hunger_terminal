class ImportCsvWorkerJob < ApplicationJob
  queue_as :default

  def perform(company_id, terminal_id, menu_items)
    message = nil
    @company = Company.find company_id 
    @terminal = @company.terminals.find terminal_id
    CSV.parse(menu_items.to_s,headers: true) do |row|
      next if row.to_a == ["name","price","veg","description","active_days"]
      row["active_days"] = row["active_days"].split(',').map{|day| day.strip}
      @menu_item = @terminal.menu_items.build(row.to_h)
      if @menu_item.valid?
        unless @menu_item.persisted?
          @menu_item.save!
          unless message 
            message = "Records Uploaded!"
          end
        end
      else
        message = "Some Records are Invalid!"
        #Add code to genearate file to handle Invalid Records
      end      
    end 
    return message
  end
end
