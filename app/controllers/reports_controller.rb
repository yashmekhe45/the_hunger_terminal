
class ReportsController < ApplicationController

  include Reports

  before_action :load_company

  add_breadcrumb "Home", :root_path

  add_breadcrumb " Employee's Current Balance Report", :mtd_reports_users_path, only: [:employees_current_month]

  add_breadcrumb "Individual Employee Report", :todays_reports_users_path, only: [:individual_employee]


  add_breadcrumb "Employees' Last Month Report", :history_reports_users_path, only: [:monthly_all_employees]

  add_breadcrumb "Terminals' Today's Report", :todays_reports_terminals_path, only: [:terminals_todays]

  add_breadcrumb "Terminals' Last Month's Report", :history_reports_terminals_path, only: [:terminals_history]

  add_breadcrumb "Individual Terminal Report", :history_reports_terminal_path, only: [:terminal_history]

  add_breadcrumb "Employee wise Today's Orders", :todays_reports_users_path, only: [:employees_daily_order_detail]

	def employees_current_month
    authorize! :employees_current_month, :report_management
    @users = User.employee_report(current_user.company_id)
  end

  def monthly_all_employees
    authorize! :monthly_all_employees, :report_management
    @from_date = params[:from] || Date.today.beginning_of_month.strftime('%Y-%m-%d')
    @to_date = params[:to] || Date.today.strftime('%Y-%m-%d')
    @users = User.employee_last_month_report(current_user.company_id, @from_date, @to_date)
    respond_to do |format|
      format.html
      format.js
      format.pdf do
        generate_pdf("monthly_all_employees")
      end
    end 
  end
  
  def employee_history
    @user_orders = User.employee_individual_report(current_user.company_id,params[:id])
    @name = @user_orders.first&.name
  end

  def employees_daily_order_detail
    authorize! :employees_daily_order_detail , :report_management
    @orders = Order.employees_daily_order_detail_report(current_user.company_id)
    respond_to do |format|
      format.html
      format.pdf do
        generate_pdf("employees_daily_order_detail")
      end
    end 
  end

  def terminals_history
    authorize! :terminals_history , :report_management
    @terminals = Terminal.all_terminals_last_month_reports(current_user.company_id)
  end


  def terminals_todays
    authorize! :terminals_todays , :report_management
    @terminals = Terminal.all_terminals_todays_order_details(current_user.company_id)
    @todays_terminals = Terminal.all.all_terminals_todays_orders_report(current_user.company_id)
    respond_to do |format|
      format.html
      format.pdf do
        generate_pdf("terminals_todays")
      end
    end 
  end

  def terminal_history
    @terminal_reports = TerminalReport.all.where(terminal_id:params[:id].to_i)
  end

  def order_details
    authorize! :order_details, :report_management
    @order_details = OrderDetail.where(order_id: params[:order_id])
  end

  private 

  def load_company
    @company = current_user.company
  end
end