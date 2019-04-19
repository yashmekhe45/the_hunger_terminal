class MenuItemsUploadService

  def initialize(params)
    @file = params[:file]
    @terminal_id = params[:terminal_id]
    @company_id = params[:company_id]
  end

  def upload_records
    message_hash = Hash.new
    if ['text/csv', 'application/octet-stream'].include?(@file.content_type)
      csv_file = File.open(@file.path)
      menu_items = CSV.parse( csv_file, headers: true )
      if menu_items.headers == ["name","price","veg","description","active_days"]
        result = ImportCsvWorkerJob.perform_now(@company_id, @terminal_id, menu_items)
        message_hash[:value] = result
      else
        message_hash[:value] = "Invalid Headers!"    
      end  
    else
      message_hash[:value] = "Invalid File Type"
    end
    return message_hash 
  end
end