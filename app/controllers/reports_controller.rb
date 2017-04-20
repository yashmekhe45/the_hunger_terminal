
class ReportsController < ApplicationController

	def index
      @users = User.employee_report(current_user.company_id)
	end

  def employees_todays_orders
    @users =  User.employees_todays_orders_report(current_user.company_id)
  end

  def monthly_all_employees
    @users = User.employee_last_month_report(current_user.company_id, Time.now-1.month)
  end

  def individual_employee
    @orders = User.employee_individual_report(current_user.company_id,params[:user_id])
  end

  def order_details
    @order_details = OrderDetail.where(order_id:params[:order_id])
  end

  def download_pdf
    require "prawn"
    require "prawn/table"
    @users = User.employee_last_month_report(current_user.company_id, Time.now-1.month)
    respond_to do |format|
      format.pdf do
        pdf = Prawn::Document.new
        table_data = Array.new
        table_data << ["Sr No", "Employee Id", "Employee Name", "TotalOrderPrcie", "subsidy", "CTE"]
        @users.each_with_index do |user,i|
            table_data << [i+1, user.id, user.name, user.total, user.subsidy, user.total - user.subsidy]
        end

        pdf.text "#{Date.today}", :align => :right
        pdf.text "#{current_user.company.name.capitalize}", :align => :center, :size => 30, style: :bold
        pdf.text "Employee Monthly Report", :align => :center, :size => 20
        pdf.table(table_data, :width => 500, :cell_style => { :inline_format => true }, :position => :center)
        send_data pdf.render, filename: "#{Time.zone.now.strftime("%B%Y")}_#{current_user.company.name}.pdf", type: 'application/pdf', :disposition => 'inline'
      end
    end
  end

  def all_terminals_last_month_reports
    @terminals = Terminal.all_terminals_last_month_reports(current_user.company_id)
  end

  def all_terminals_daily_report
    @terminals = Terminal.all_terminals_todays_order_details(current_user.company_id)
    @todays_terminals = Terminal.daily_terminals(current_user.company_id)
  #   @terminals =  Order.all_terminals_daily_report(current_user.company_id)
  end

  def individual_terminal_last_month_report
    @terminal_reports = TerminalReport.all.where(terminal_id:params[:terminal_id].to_i)
  end
end