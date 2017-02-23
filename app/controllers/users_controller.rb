class UsersController < ApplicationController

  require 'csv'

  before_action :load_user , only:[:show, :edit, :update]

  def new
    @company = Company.new
    @user = @company.employees.build
  end

  def index
    @company = Company.find(params[:company_id])
    @users = @company.employees.where(role: "employee").order(:created_at).page(params[:page]).per(5)  
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
        redirect_to "#{company_users_path(params[:company_id])}" + "?page=" + "#{params[:page]}"
      end
    else
      flash[:error]= @user.errors.messages
      if(@user.role == "company_admin")
        render :edit_company_admin
      else
        redirect_to company_users_path(params[:company_id],:page=>params[:page])
      end
    end
  end

  def search
    search_value = params[:search_value]
    p search_value
    if search_value
      @company = Company.find_by(id: params[:company_id])
      @users = @company.employees.where(role: "employee").where("name like ? or email like ?",
              "%#{search_value}%","%#{search_value}%").all.order('created_at').page(params[:page]).per(2)
    else
      render "index"
    end
  end


  private

  def user_params
    params.require(:user).permit(:id,:name,:email,:is_active,:mobile_number, :password)
  end

  def load_user
    @company = Company.find(params[:company_id])
    @user = @company.employees.find(params[:id])
  end

end
