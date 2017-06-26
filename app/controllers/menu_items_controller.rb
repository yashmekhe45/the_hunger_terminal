class MenuItemsController < ApplicationController
  
  load_and_authorize_resource  param_method: :menu_item_params

  before_action :authenticate_user!  

  before_action :load_company, except: [:download_csv]
  before_action :load_terminal, except: [:download_csv]

  before_action :load_menu_item, only: [ :edit, :update, :destroy ]
  load_and_authorize_resource

  add_breadcrumb "Home", :root_path
  # add_breadcrumb "Terminals", :company_terminals_path, only: [:index]

  
  def index
    if params[:search_item].present?
      @menu_items = @terminal.menu_items.where(["LOWER(name) LIKE ?", "%#{params[:search_item].downcase}%"]).page(params[:page]).per(6)
      if @menu_items.empty?
        flash[:notice] = "Meu Item is not present."
      end
    else 
      @menu_items = @terminal.menu_items.order(:name).page(params[:page]).per(6)
    end
    add_breadcrumb @terminal.name+" Menu"
  end

  def new
    @menu_item = @terminal.menu_items.new
  end

  def create
    @menu_item = @terminal.menu_items.create(menu_item_params)
    flash[:success] = 'New Menu Item Added'
  end

  def edit
  end

  def update
    if @menu_item.update_attributes(menu_item_params)
      flash[:success] = "Menu Item updated"
      redirect_to terminal_menu_items_path(@terminal) and return
    else
      flash[:error] = "can't update menu_item"
      render :edit and return
    end
  end

  def import
    unless params[:file].nil?
      valid_csv
    end
    redirect_to terminal_menu_items_path(@terminal)
  end
  
  def valid_csv    
    if params[:file].content_type == "text/csv"
      csv_file = File.open(params[:file].path)
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

  def download_csv
    send_file(
    "#{Rails.root}/public/menu.csv",
    type: "application/csv"
  )
  end

  private

  def load_company
    @current_company = current_user.company
  end

  def load_terminal
    @terminal = @current_company.terminals.find params[:terminal_id]
  end

  def load_menu_item
    @menu_item = @terminal.menu_items.find(params[:id])
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :price, :veg, :available, :terminal_id, :description, active_days: [])
  end

end
