class MenuItemsController < ApplicationController
  
  before_action :authenticate_user!  
  before_action :load_company
  before_action :load_terminal
  before_action :load_menu_item, only: [ :edit, :update, :destroy ]

  def menu_index
  	@company = Company.find(params[:company_id])
  	@terminals = @company.terminals.where(:available => true).ids
  	@menus = MenuItem.where(:terminal_id => @terminals)
  end	

  def index
    @menu_items = @terminal.menu_items.page params[:page]
  end

  def new
    @menu_item = @terminal.menu_items.new
  end

  def create
    @menu_item = @terminal.menu_items.create(menu_items_params)
  end

  def edit
    render 'new'
  end

  def update
    @menu_item.update_attributes(menu_items_params)
    flash[:success] = "Menu Item updated"
    render 'create'
  end

  def destroy
    @menu_item.destroy
    flash[:success] = 'Menu Item Deleted successfully'
    redirect_to company_terminal_path(@current_company,@terminal)
  end
  
  private

  def load_company
    @current_company = current_user.company
    unless @current_company
      flash[:warning] = 'Company not found'
      redirect_to root_path and return
    end
  end

  def load_terminal
    @terminal = @current_company.terminals.find params[:terminal_id]
    unless @terminal
      flash[:warning] = 'Terminal not found'
      redirect_to terminals_path and return
    end
  end

  def load_menu_item
    @menu_item = @terminal.menu_items.find(params[:id])
    unless @menu_item
      flash[:warning] = "MenuItem not found"
      redirect_to terminal_menu_items_path(@terminal) and return
    end
  end

  def menu_items_params
    params.require(:menu_item).permit(:name, :price, :veg, :available, :terminal_id, active_days: [])
  end

end
