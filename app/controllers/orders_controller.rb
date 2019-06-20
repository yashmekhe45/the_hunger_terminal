class OrdersController < ApplicationController

  skip_before_action :authenticate_user!, only: :one_click_order
  load_and_authorize_resource  param_method: :order_params, except: :one_click_order
  before_action :require_permission, only: [:show, :edit, :update, :delete]
  before_action :load_terminal_and_order, only: [:show, :edit, :update, :delete]
  
  add_breadcrumb "Home", :root_path, except: [:one_click_order]
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
    respond_to do |format|
      format.html
      format.js
    end
  end

  def load_terminal
    @terminals = Terminal.where(active: true, company: current_user.company)
                         .select(:id, :name, :min_order_amount,
                                 :tax, 'avg(reviews.rating) as rating')
                         .left_outer_joins(:reviews)
                         .group(:id)
                         .order('rating desc nulls last')
    @end_ordering_at = current_user.company.end_ordering_at.strftime('%H:%M:%S')
    @review = Review.new
    @order = current_user.orders.last
  end

  def new
    @terminal = Terminal.find(params[:terminal_id])
    @subsidy = current_user.company.subsidy
    @order = Order.new(company_id: current_user.company.id)
    @veg = Order.veg_items(@terminal.id)
    @nonveg = Order.nonveg_items(@terminal.id)
    @tax = @terminal.tax.to_i
    @avg_rating = @terminal.reviews.average(:rating).to_f
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
    @order_details = @order.order_details.includes(:menu_item)
    order_menus = @order.order_details.pluck(:menu_item_id)
    terminal_menus = @terminal.menu_items.pluck(:id)
    unique_item =  terminal_menus - order_menus
    @terminal_id = @terminal.id
    @menu_items = Order.unordered_items(@terminal_id, unique_item) unless unique_item.empty?
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
    @order.destroy
    flash[:success] = "Your order has been deleted successfully"
    redirect_to vendors_path
  end  

  def one_click_order
    if params[:token]
      one_click_order_obj = OneClickOrder.find_by(order_id: params[:order_id], token: params[:token])
      if one_click_order_obj
        old_order = Order.find(params[:order_id])
        @new_order = old_order.dup
        @new_order.status = "pending"
        @new_order.date = Time.zone.today
        old_order.order_details.each do |order_detail|
          new_order_detail = order_detail.dup
          @new_order.order_details << new_order_detail
        end
        @new_order.save 
      end
    end
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

end
