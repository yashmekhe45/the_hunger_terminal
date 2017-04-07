require 'csv'
class TerminalsController < ApplicationController

  load_and_authorize_resource param_method: :terminal_params

  
  before_action :authenticate_user!  
  before_action :load_company
  before_action :load_terminal, only: [:show, :edit, :update, :destroy]

  def new
    @terminal = @current_company.terminals.build
    @terminal.menu_items.build  
  end
  
  def create
    @terminal = @current_company.terminals.build terminal_params
    if @terminal.save
      flash[:success] = "terminal created successfully" 
      unless params[:terminal][:CSV_menu_file].nil?
        valid_csv
      end
      redirect_to company_terminal_menu_items_path(@current_company,@terminal) and return
    else
      render :new and return
    end
    render :new
  end

  def index
    if params[:search].present?
      search_type = params[:search]
      @terminals = @current_company.terminals.where(["LOWER(name) LIKE :search OR landline LIKE :search", search: "%#{params[:search].downcase}%"]).page(params[:page]).per(6)
      if @terminals.empty?
        flash[:notice] = "Vendor not present."
      end
    else
      @terminals = @current_company.terminals.order(:name).page(params[:page]).per(6)
    end
  end

  def edit
  end

  def show

    if params[:id] == "download"
      invalid_menus_download
    end
  end  

  def update
    if @terminal.update_attributes(terminal_params)
      flash[:success] = "terminal updated"
      redirect_to company_terminals_path and return
    else
      flash[:error] = @terminal.errors.messages
      render :edit and return
    end
  end

  def destroy
    @terminal.destroy
    redirect_to company_terminals_path
  end 
 
  def valid_csv    
    if params[:terminal][:CSV_menu_file].content_type == "text/csv"
      csv_file = File.open(params[:terminal][:CSV_menu_file].path)
      menu_items = CSV.parse( csv_file, headers: true )
      if menu_items.headers == ["name","price","veg","description","active_days"]
        ImportCsvWorkerJob.perform_now(@current_company.id, @terminal.id, menu_items) 
        # if !$INVALID_MENU_CSV.nil?
        #   redirect_to import_company_terminal_path(@current_company,@terminal)
        # end
      else
        flash[:error] = "Invalid headers with name,price,veg,active_days,description" and return    
      end  
    else
      flash[:error] = "Invalid type of file" and return
    end 
  end

  def download
    send_file("#{$INVALID_MENU_CSV}")
  end

  private

  def terminal_params
    params.require(:terminal).permit(:name,:landline, :active, :email, :min_order_amount, :company_id, :image)
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
end
    