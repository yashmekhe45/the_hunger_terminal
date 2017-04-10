class ReportsController < ApplicationController

	def index
    if params[:todays_orders] == "Todays orders"
      @users =  User.employees_todays_orders_report(current_user.company_id)
    elsif params[:last_month_orders] ==  "last months orders"
	     @users = User.employee_last_month_report(current_user.company_id, Time.now-1.month)
    else
      @users = User.employee_report(current_user.company_id)
    end 
	# authorize! :index, :order_management 
	end

  def individual_employee
    @orders = User.employee_individual_report(current_user.company_id,params[:user_id])
  end

end
