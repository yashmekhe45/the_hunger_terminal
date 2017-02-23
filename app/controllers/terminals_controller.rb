require 'csv'
class TerminalsController < ApplicationController
  def new
    @terminal = Terminal.new
    @terminal.menu_items.build
  end
  
  def create
   @terminal = Terminal.new(terminal_param)
     if @terminal.save
        redirect_to terminals_path
      else
        render :new
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
      @terminal = Terminal.order(:name)
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
    if @terminal.update_attributes(terminal_param)
      flash[:success] = "terminal updated"
      if @terminal.menu_items.empty?
        @terminal.destroy
        redirect_to terminals_path
      else
        redirect_to terminal_path
      end
    else
      render 'edit'
    end
  end

  def destroy
    @terminal = Terminal.find(params[:id])
    @terminal.destroy
    redirect_to terminals_path
  end

  def import
    @terminal = Terminal.find(params[:id])
    @menu_item_errors = MenuItem.new(name:"cxkvbivbad",price:2424,veg:true,terminal_id:@terminal.id)
    $INVALID_RECORD_CSV = nil
    csv_file = File.open(params[:file].path)
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
        flash[:success] = "all menu items added"
        redirect_to terminal_path(@terminal.id)
      else
        flash[:alert] = "You have invalid some records.Correct it and upload again." 
      end     
    else
      flash[:error] = "You have invlaid csv please upload csv with valid headers."
      redirect_to terminals_path
    end   
  end 

  private

  def terminal_param
    params.require(:terminal).permit(:name,:landline, menu_items_attributes: [:id, :name, :veg, :price, :_destroy])
  end

  def download
    send_file("#{Rails.root}/#{$INVALID_RECORD_CSV}")
  end
end
