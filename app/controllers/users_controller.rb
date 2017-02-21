class UsersController < ApplicationController

  before_action :load_user , only:[:show, :index, :edit, :update]

  def new
    @user = User.new
    @company = Company.new
  end

  def index
    @users = @company.employees.page(params[:page]).per(1)  
  end
  
  def update
    page = 1

    if @user.update(user_params)
      #Company admin will be updated by Super Admin
      if (@user.role == "company_admin")
        redirect_to companies_path
      #Employess will be activated/deactivated by Company admin
      else
        render company_users_path(params[:company_id],:page=>params[:page])
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

  private

  def user_params
    params.require(:user).permit(:id,:name,:email,:is_active,:mobile_number, :password)
  end

  def load_user
    @company = Company.find(params[:company_id])
    @user = User.find(params[:id])
  end

end
