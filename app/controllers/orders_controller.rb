class OrdersController < ApplicationController

  load_and_authorize_resource  
  before_action :require_permission, only: [:show, :edit, :update, :delete]
  before_action :load_terminal_and_order, only: [:show, :edit, :update, :delete]
  
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Terminals", :vendors_path, only: [:new, :create, :load_terminal]
  add_breadcrumb "My Order History", :orders_path, only: [:order_history]
  add_breadcrumb "Today's Order", :order_path, only: [:show, :edit, :update]

  def order_history
    @from_date = params[:from] || 7.days.ago.strftime('%Y-%m-%d')
    @to_date = params[:to] || Date.today.strftime('%Y-%m-%d')
    @orders = current_user.orders.includes(:order_details).includes(:terminal).where(status: "confirmed",date: Date.parse(@from_date)..Date.parse(@to_date)).order(date: :desc)
    if @orders.empty?
      flash[:error] = "No order is present for this period!"
    end
  end

  def load_terminal
    @terminals = Terminal.where(active: true, company: current_user.company)
  end

  def new 
    @terminal = Terminal.find(params[:terminal_id])
    @subsidy = current_user.company.subsidy
    @order = Order.new(company_id: current_user.company.id)
    @terminal_id = params[:terminal_id]
    @veg = get_veg_menu_items
    @nonveg = get_nonveg_menu_items
    @tax = @terminal.tax.to_i
    add_breadcrumb @terminal.name, new_terminal_order_path
  end

  def create                                                                                                                          
    @order = Order.new(order_params)
    load_order_detail
    if @order.save
      flash[:notice] = "your order has been placed successfully. You will receive an email confirmation shortly."
      redirect_to order_path(@order)
    else
      if @order.errors.full_messages.include?("User has already been taken")
        flash[:error] = "Only one order is allowed per day"
      else
        flash[:error] = @order.errors.full_messages.join(",")
      end 
      redirect_to vendors_path
    end
  end

  def edit
    @subsidy = current_user.company.subsidy
    @tax = @terminal.tax.to_i
    @order_details = @order.order_details.all.includes(:menu_item) 
    oder_menus = @order.order_details.pluck(:menu_item_id)
    terminal_menus = @terminal.menu_items.pluck(:id)
    unique_item =  terminal_menus-oder_menus
    @terminal_id = @terminal.id
    if !unique_item.empty?
      @menu_items = MenuItem.where(terminal_id: @terminal.id).where("active_days @> ARRAY[?]::varchar[]",[Time.zone.now.wday.to_s]).where(available: true).where(:id => unique_item)
    end
    add_breadcrumb "Edit Order"
  end

  def update
    if @order.update_attributes(order_params) 
      flash[:notice] = "Your order has been updated successfully"
      redirect_to order_path(@order)
    else
      flash[:error] = @order.errors.full_messages.join(",")
      redirect_to order_path(@order)
    end
  end


  def destroy
    # @order = Order.find(params[:id])
    @order.destroy
    flash[:success] = "Your order has been deleted successfully"
    redirect_to vendors_path
  end  

  private

    def load_terminal_and_order
      @order = Order.find(params[:id])
      @terminal = Terminal.find(@order.terminal_id) 
    end

    def order_params
      params.require(:order).permit(
        :total_cost,:terminal_id,:id, order_details_attributes:[:menu_item_id, :quantity, :id,:_destroy]
      ).merge(user_id: current_user.id)
    end

    def load_order_detail
      @order.date = Time.zone.today
      @order.company_id = current_user.company.id
    end

    def require_permission
      if current_user != Order.find(params[:id]).user
        flash[:error] = "You are not authorized to access it!!"
        redirect_to root_path
      end
    end

    def get_veg_menu_items
      return MenuItem.where(terminal_id: params[:terminal_id]).where("active_days @> ARRAY[?]::varchar[]",[Time.zone.now.wday.to_s]).where("available = ? AND veg = ?",true,true)
    end

    def get_nonveg_menu_items
      return MenuItem.where(terminal_id: params[:terminal_id]).where("active_days @> ARRAY[?]::varchar[]",[Time.zone.now.wday.to_s]).where("available = ? AND veg = ?",true,false)
    end

end
