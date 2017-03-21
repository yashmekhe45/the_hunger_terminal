require 'csv'
class TerminalsController < ApplicationController
  def new
    @terminal = Terminal.new
    @terminal.menu_items.build
  end
  
  def create
    flag = true
    valid_menus = params[:terminal][:menu_items_attributes]
    valid_menus.each do |valid_menu|
      if valid_menus[valid_menu][:name].empty? || valid_menus[valid_menu][:price].empty?
        @terminal = Terminal.new(terminal_param)
        flag = false
        if @terminal.save
          flash[:success] = "Only new terminal added"
          if params[:terminal][:file].nil?
            redirect_to terminals_path
          else
            import(@terminal.id)
          end
        else
          render :new 
        end 
      end 
    end 
    if flag
      @terminal = Terminal.new(terminal_menu_param)
      if @terminal.save
        flash[:success] = "terminal with menu items added"
        if params[:terminal][:file].nil?
            redirect_to terminals_path
          else
            import(@terminal.id)
        end
      else
        render :new
      end
    end
  end

  

  def index
    if params[:search].present?
      search_type = params[:search]
      @terminal_search = Terminal.where(["name LIKE ?", "%#{params[:search]}%"])
      if @terminal_search.empty?
        flash[:notice] = "Vendor not present."
      end
    else
      @terminal = Terminal.order(:name).page(params[:page]).per(7)
    end
  end

  def edit
    @terminal = Terminal.find(params[:id])
  end

  def show
    if params[:id] == "download"
      download
    else  
      @terminal = Terminal.find(params[:id])
      @menu_items = @terminal.menu_items.all
    end
  end  

  def update
    @terminal = Terminal.find(params[:id])
    if @terminal.update_attributes(terminal_menu_param)
      flash[:success] = "terminal updated"
      if params[:terminal][:file].nil?
        if @terminal.menu_items.empty?
          flash[:alert] = "you deleted all items so your terminal is deleted"
          @terminal.destroy
          redirect_to terminals_path
        else
          redirect_to terminal_path
        end
      else
        import(params[:id])
      end
    else
      render :edit
    end
  end

  def destroy
    @terminal = Terminal.find(params[:id])
    @terminal.destroy
    redirect_to terminals_path
  end

  def import(object_id)
    @terminal = Terminal.find(object_id)
    @menu_item_errors = MenuItem.new(name:"cxkvbivbad",price:2424,veg:true,terminal_id:@terminal.id)
    $INVALID_RECORD_CSV = nil
    csv_file = File.open(params[:terminal][:file].path)
    menu_items = CSV.parse(csv_file, headers: true)
    if menu_items.headers == ["name","price","veg"]
      menu_items.each do |row|
        next if row.to_a == ["name","price","veg"]
        @menu_item = @terminal.menu_items.build(row.to_h)
        if @menu_item.valid?
          @menu_item.save
        else
          CSV.open($INVALID_RECORD_CSV="public/#{@terminal.name}-invalid_records-#{Date.today}.csv", "a+") do |csv|
            row << @menu_item.errors.messages.to_a
            csv << row
          end
          @menu_item_errors = @menu_item
        end
      end
      if @menu_item_errors.valid?
        flash[:success] = "all menu items added using csv file"
        redirect_to terminal_path(@terminal.id)
      else
        flash[:alert] = "You have invalid some records.Correct it and upload again." 
        redirect_to terminal_path(@terminal.id)
      end     
    else
      flash[:error] = "You have invlaid csv please upload csv with valid headers."
      redirect_to terminals_path
    end   
  end 

  private

  def terminal_param
    params.require(:terminal).permit(:name,:landline)
  end

  def terminal_menu_param
    params.require(:terminal).permit(:name,:landline, menu_items_attributes: [:id, :name, :veg, :price, :_destroy])
  end

  def download
    send_file("#{Rails.root}/#{$INVALID_RECORD_CSV}")
  end
end
