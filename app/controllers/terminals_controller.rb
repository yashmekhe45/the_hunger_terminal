require 'csv'
class TerminalsController < ApplicationController

  load_and_authorize_resource
  
  before_action :authenticate_user!  
  before_action :load_company
  before_action :load_terminal, only: [:show, :edit, :update, :destroy, :import]

  def new
    @terminal = @current_company.terminals.build
    @terminal.menu_items.build  
  end
  
  def create
    @terminal = @current_company.terminals.build terminal_param
    if @terminal.save
      flash[:success] = "terminal created successfully" 
      unless params[:terminal][:file].nil?
        valid_csv
      end
      redirect_to company_terminal_menu_items_path(@current_company,@terminal)
    else
      render :new and return
    end
  end

  def index
    if params[:search].present?
      @terminals = @current_company.terminals.where(["LOWER(name) LIKE ?", "%#{params[:search].downcase}%"]).page(params[:page]).per(7)
      if @terminals.empty?
        flash[:notice] = "terminal not present."
      end
    else
      @terminals = @current_company.terminals.order(:name).page(params[:page]).per(7)
    end
  end

  def edit
    # render :new
  end

  def show
    if params[:id] == "download"
      download
    end
  end  

  def update
    if @terminal.update_attributes(terminal_param)
      flash[:success] = "terminal updated"
      if params[:terminal][:file].nil?
        redirect_to company_terminals_path and return
      else
        render :edit and return
      end
    end
  end

  def destroy
    @terminal.destroy
    redirect_to company_terminals_path and return
  end

  def import
    @company = Company.find(params[:company_id])
    @terminal = @company.terminals.find(object_id)
    @menu_item_errors = MenuItem.new(name:"cxkvbivbad",price:2424,veg:true,terminal_id:@terminal.id)
    $INVALID_RECORD_CSV = nil
    csv_file = File.open(params[:terminal][:file].path)
    if params[:terminal][:file].content_type == "text/csv"  
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
          redirect_to company_terminal_path(@terminal.id)
        else
          flash[:alert] = "You have invalid some records.Correct it and upload again." 
          redirect_to company_terminal_path(@terminal.id)
        end     
      else
        flash[:error] = "You have invlaid csv please upload csv with valid headers."
        redirect_to company_terminals_path
      end
    else
      flash[:alert] = "Invalid type of file.Please upload csv file"
      redirect_to company_terminals_path
    end        
  end 
 
  def valid_csv 
    if params[:terminal][:file].content_type == "text/csv"
      csv_file = File.open(params[:terminal][:file].path)
      menu_items = CSV.parse( csv_file, headers: true )
      if menu_items.headers == ["name","price","veg","active_days","description"]
        invalid_menu_file = ImportCsvWorker.perform_async(@current_company.id, @terminal.id, menu_items) 
        # unless invalid_menu_file.nil?
        #   redirect_to company_terminal_path(params[:custom_action]=="download")
        # end
      else
        flash[:error] = "Invalid headers with name,price,veg,active_days,description" and return    
      end  
    else
      flash[:error] = "Invalid type of file" and return
    end 
  end

  private

  def terminal_param
    params.require(:terminal).permit(:name,:landline, :active, :email, :min_order_amount, :company_id, :image,)
  end

  def load_company
    @current_company = current_user.company
    unless @current_company
      flash[:warning] = 'Company not found'
      redirect_to root_path and return
    end
  end

  def load_terminal
    @terminal = @current_company.terminals.find params[:id]
    unless @terminal
      flash[:warning] = 'Terminal not found'
      redirect_to terminals_path and return
    end
  end

  def download
    send_file("#{Rails.root}/#{invalid_menu_file}")
  end
end
