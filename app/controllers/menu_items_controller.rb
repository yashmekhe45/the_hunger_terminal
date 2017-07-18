class MenuItemsController < ApplicationController

  load_and_authorize_resource :user
  load_and_authorize_resource :company
  load_and_authorize_resource :terminal  
  load_and_authorize_resource  param_method: :menu_item_params
 
  before_action :load_company, except: [:download_csv]
  before_action :load_terminal, except: [:download_csv, :download_invalid_csv]
  before_action :load_menu_item, only: [ :edit, :update, :destroy ]

  add_breadcrumb "Home", :root_path
  
  def index
    if params[:search_item].present?
      @menu_items = @terminal.menu_items.where(["LOWER(name) LIKE ?", "%#{params[:search_item].downcase}%"]).page(params[:page]).per(6)
      if @menu_items.empty?
        flash[:notice] = "Menu Item is not present."
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
    @menu_item = @terminal.menu_items.build(menu_item_params)
    if @menu_item.save
      flash[:success] = 'New Menu Item Added'
    else
      flash[:error] = @menu_item.errors[:active_days].join(', ')
    end
  end

  def update
    if @menu_item.update(menu_item_params)
      flash[:success] = "Menu Item updated"
      redirect_to terminal_menu_items_path(@terminal) and return
    else
      flash[:error] = "can't update menu_item"
      render :edit and return
    end
  end

  def import
    unless params[:file].nil?
      result = MenuItemsUploadService.new(file: params[:file],terminal_id: @terminal.id, company_id: @current_company.id).upload_records
      flash[:notice] = result[:value]
      redirect_to terminal_menu_items_path(@terminal)     
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
    @terminal = Terminal.find params[:terminal_id]
  end

  def load_menu_item
    @menu_item = MenuItem.find(params[:id])
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :price, :veg, :available, :terminal_id, :description, active_days: [])
  end

end
