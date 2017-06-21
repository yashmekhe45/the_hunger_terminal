require 'csv'

class UsersController < ApplicationController

  load_and_authorize_resource param_method: :user_params 
  before_action :require_permission, except: [:download_sample_file]
  before_action :load_user , only:[:show, :edit, :update]
  before_action :load_company, except: [:download_invalid_csv,
    :download_invalid_xls, :download_invalid_xlsx, :download_sample_file]

  respond_to :html, :json

  add_breadcrumb "Home", :root_path
  add_breadcrumb "Employees", :company_users_path, only: [:index, :show, :search]
  add_breadcrumb "Employee Detail", :company_user_path, only: [:show]


  def new
    @company = Company.new
    @user = @company.employees.build
  end

  def create
    @user = @company.employees.build(:name => user_params[:name],
     :email => user_params[:email], :mobile_number => user_params[:mobile_number],
      :is_active =>true, :role => "employee",:password=> Devise.friendly_token.first(8))

    if @user.valid?
      @user.save
      flash[:success] = "Employee record added!!"
      # redirect_to company_users_path
    else
      flash.now[:error]=  @user.errors.messages
      render :new 
    end
  end

  def index
    @users = @company.employees.includes(:company).where(role: "employee").order(:created_at).page(params[:page]).per(4)
    if @users.empty?
      flash.now[:error] = "Sorry, No record is found"
      render "index"
    end
    add_breadcrumb @company.name, company_users_path
  end
  
  def update
    page = 1
    if !params[:page]
      params[:page] = page
    end
    if @user.update(user_params)
      flash[:success] = "Status changed successfully!!"
      redirect_to company_users_path(@company,:page=>params[:page])
    else
      flash.now[:error]= @user.errors.messages
      redirect_to company_users_path(@company,:page=>params[:page])
    end
  end



  def import
  end

  def add_multiple_employee_records
    p params[:file]
    if !params[:file]
      flash[:error] = "Please select a file."
      # redirect_to company_users_path(params[:company_id])
      redirect_to import_company_users_path(params[:company_id])
    else
      result = User.import(params[:file], params[:company_id])
      if result == 1
        redirect_to company_users_path(params[:company_id]), notice: "User records imported"
      elsif result == 0
        redirect_to company_users_path(params[:company_id]), notice: "Record Already exists!"
      elsif result == -1
        redirect_to company_users_path(params[:company_id]), notice: "Invalid record!"
      end
    end 
  end

  def search
    search_value = params[:search_value].downcase
    @users = @company.employees.includes(:company).where(role: "employee").where("lower(name) like ? or
     lower(email) like ?", "%#{search_value}%","%#{search_value}%").all.
     order('created_at').page(params[:page]).per(5)
    if @users.empty?
      flash.now[:error] = "No record found"
      render "index"
      # redirect_to company_users_path(params[:company_id])
    else
      add_breadcrumb "Search Results"
    end  
  end

  def download_invalid_csv
    if "#{Rails.root}/#{$INVALID_USER_CSV}"
      send_file("#{Rails.root}/#{$INVALID_USER_CSV}")
    else
      flash[:error] = "No invalid record"
      redirect_to company_users_path(@company.id)
    end
  end

  def download_invalid_xls
  end

  def download_invalid_xlsx
  end

  def download_sample_file
    file_type = params[:file_type]

    case file_type
    when 'csv' then 
      send_file("#{Rails.root}/public/employees.csv",
        type: "application/csv")
    when 'xls' then 
      send_file("#{Rails.root}/public/employees.xls",
        type: "application/xls") 
    when 'xlsx' then 
      send_file("#{Rails.root}/public/employees.xlsx",
        type: "application/xlsx")
    # else raise "Unknown file type: #{file.original_filename}"
    end
  end


  def user_params
    params.require(:user).permit(:id,:name,:email,:is_active,:mobile_number, :password)
  end

  
  private

  def load_user
    @company = Company.find(current_user.company_id)
    @user = @company.employees.find(params[:id])
  end

  def load_company
    @company = Company.find(current_user.company_id)  
  end

  def require_permission
    if current_user != Company.find(params[:company_id]).employees.find_by(role: "company_admin")
      flash[:error] = "You are not authorized to access it!!"
      redirect_to vendors_path
    end
  end

end
