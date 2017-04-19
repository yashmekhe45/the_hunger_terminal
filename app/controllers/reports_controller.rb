
class ReportsController < ApplicationController

  # before_filter :login_required, :only => [:index, :employee_report, :monthly_all_employees, :individual_employee, :all_terminals_last_month_reports]
  # before_action :load_company, only: [:all_terminals_daily_report]


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
    @todays_terminals = Terminal.all_terminals_todays_orders_report(current_user.company_id)
     # html = render :layout => false 
    respond_to do |format|
      format.html
      format.pdf do
        kit = PDFKit.new('http://localhost:3000/reports/all_terminals_daily_report', :page_size => 'A3')
        send_data(kit.to_pdf, :filename => "your_pdf_name.pdf", :type => 'application/pdf',:disposition => 'inline')
      end
    end 
   
  #   @terminals =  Order.all_terminals_daily_report(current_user.company_id)
  end

  def individual_terminal_last_month_report
    @terminal_reports = TerminalReport.all.where(terminal_id:params[:terminal_id].to_i)
  end

  def download_daily_terminal_report

  end

  private 

  def load_company
    @current_company = current_user.company
    unless @current_company
      flash[:warning] = 'Company not found'
      redirect_to root_path and return
    end
  end
end