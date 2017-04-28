require 'csv'

class UsersController < ApplicationController

  load_and_authorize_resource param_method: :user_params 

  before_action :load_user , only:[:show, :edit, :update]
  before_action :load_company, only: [:index, :import, :search, :new, :create]

  respond_to :html, :json

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
    @users = @company.employees.where(role: "employee").order(:created_at).page(params[:page]).per(4)
    if @users.empty?
      flash.now[:error] = "Sorry, No record is found"
      render "index"
    end
  end
  
  def update
    page = 1
    if !params[:page]
      params[:page] = page
    end
    if @user.update(user_params)
      #Company admin will be updated by Super Admin
      if (@user.role == "company_admin")
        redirect_to "#{companies_path}" + "?page=" + "#{params[:page]}"
      #Employess will be activated/deactivated by Company admin
      else
        flash[:success] = "Status changed successfully!!"
        redirect_to "#{company_users_path(params[:company_id])}" + "?page=" + "#{params[:page]}"
      end
    else
      flash.now[:error]= @user.errors.messages
      if(@user.role == "company_admin")
        render :edit_company_admin
      else
        redirect_to company_users_path(params[:company_id],:page=>params[:page])
      end
    end
  end



  def import
    User.import(params[:file], params[:company_id])
    redirect_to company_users_path(params[:company_id]), notice: "User records imported"
  end



  def search
    search_value = params[:search_value].downcase
    @users = @company.employees.where(role: "employee").where("lower(name) like ? or
     lower(email) like ?", "%#{search_value}%","%#{search_value}%").all.
     order('created_at').page(params[:page]).per(5)
    if @users.empty?
      flash.now[:error] = "No record found"
      render "index"
      # redirect_to company_users_path(params[:company_id])
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

  def download_sample_csv
    send_file(
    "#{Rails.root}/public/employees.csv",
    type: "application/csv"
  )
  end


  def user_params
    params.require(:user).permit(:id,:name,:email,:is_active,:mobile_number, :password)
  end

  
  private

  def load_user
    @company = Company.find(params[:company_id])
    @user = @company.employees.find(params[:id])
  end

  def load_company
    @company = Company.find(params[:company_id])  
  end
end
