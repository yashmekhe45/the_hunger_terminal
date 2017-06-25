
class ReportsController < ApplicationController

  # before_filter :login_required, :only => [:index, :employee_report, :monthly_all_employees, :individual_employee, :all_terminals_last_month_reports]
  before_action :load_company

  add_breadcrumb "Home", :root_path

  # add_breadcrumb "Current Balance Report", :reports_index_path, only: [:index, :employees_todays_orders, :monthly_all_employees, :individual_employee]


  add_breadcrumb "Today's Orders' Report", :todays_orders_company_reports_path, only: [:index, :employees_todays_orders, :monthly_all_employees, :individual_employee]

  add_breadcrumb " Employee's Current Balance Report", :reports_index_path, only: [:index]

  add_breadcrumb "Individual Employee Report", :reports_individual_employee_path, only: [:individual_employee]


  add_breadcrumb "Emplyees' Last Month Report", :reports_monthly_all_employees_path, only: [:monthly_all_employees]

  add_breadcrumb "Terminals' Today's Report", :reports_all_terminals_daily_report_path, only: [:all_terminals_daily_report]

  add_breadcrumb "Terminals' Last Month's Report", :reports_all_terminals_last_month_reports_path, only: [:all_terminals_last_month_reports, :individual_terminal_last_month_report]

  add_breadcrumb "Individual Terminal Report", :reports_individual_terminal_last_month_report_path, only: [:individual_terminal_last_month_report]

  add_breadcrumb "Employee wise Orders", :reports_employees_daily_order_detail_path, only: [:employees_daily_order_detail]

	def employees_current_month
    @users = User.employee_report(current_user.company_id)
    generate_no_record_found_error(@users)
	end


  def monthly_all_employees
    @users = User.employee_last_month_report(current_user.company_id, Time.now-1.month)  
    respond_to do |format|
      format.html
      format.pdf do
        kit = PDFKit.new('http://localhost:3000/reports/users/history', :page_size => 'A3')
        send_data(kit.to_pdf, :filename => "your_pdf_name.pdf", :type => 'application/pdf',:disposition => 'inline')
      end
    end 
    generate_no_record_found_error(@users)
  end

  def employee_history
    @orders = User.employee_individual_report(current_user.company_id,params[:id])
  end

  def employees_daily_order_detail
    @orders = Order.employees_daily_order_detail_report(current_user.company_id)
    generate_no_record_found_error(@orders)
    respond_to do |format|
      format.html
      format.pdf do
        kit = PDFKit.new('http://localhost:3000/reports/users/todays', :page_size => 'A3')
        send_data(kit.to_pdf, :filename => "your_pdf_name.pdf", :type => 'application/pdf',:disposition => 'inline')
      end
    end 
  end

  # def download_pdf
  #   require "prawn"
  #   require "prawn/table"
  #   @users = User.employee_last_month_report(current_user.company_id, Time.now-1.month)
  #   respond_to do |format|
  #     format.pdf do
  #       pdf = Prawn::Document.new
  #       table_data = Array.new
  #       table_data << ["Sr No", "Employee Id", "Employee Name", "TotalOrderPrcie", "subsidy", "CTE"]
  #       @users.each_with_index do |user,i|
  #           table_data << [i+1, user.id, user.name, user.total, user.subsidy, user.total - user.subsidy]
  #       end

  #       pdf.text "#{Date.today}", :align => :right
  #       pdf.text "#{current_user.company.name.capitalize}", :align => :center, :size => 30, style: :bold
  #       pdf.text "Employee Monthly Report", :align => :center, :size => 20
  #       pdf.table(table_data, :width => 500, :cell_style => { :inline_format => true }, :position => :center)
  #       send_data pdf.render, filename: "#{Time.zone.now.strftime("%B%Y")}_#{current_user.company.name}.pdf", type: 'application/pdf', :disposition => 'inline'
  #     end
  #   end
  # end

  def terminals_history
    @terminals = Terminal.all_terminals_last_month_reports(current_user.company_id)
    generate_no_record_found_error(@terminals)
  end


  def terminals_todays
    @terminals = Terminal.all_terminals_todays_order_details(current_user.company_id)
    @todays_terminals = Terminal.all.all_terminals_todays_orders_report(current_user.company_id)
    generate_no_record_found_error(@terminals)
    respond_to do |format|
      format.html
      format.pdf do
        kit = PDFKit.new('http://localhost:3000/reports/terminals/todays', :page_size => 'A3')
        send_data(kit.to_pdf, :filename => "your_pdf_name.pdf", :type => 'application/pdf',:disposition => 'inline')
      end
    end 
  end

  def terminal_history
    @terminal_reports = TerminalReport.all.where(terminal_id:params[:id].to_i)
  end

  def download_daily_terminal_report

  end

  private 

  def load_company
    @company = current_user.company
  end

  def generate_no_record_found_error(records)
    if records.empty?
      flash[:error] = "No record found"
    end
  end
end