class CompaniesController < ApplicationController

  # load_and_authorize_resource  param_method: :compnay_params 
  before_action :load_company, only: [:update, :show, :destroy,:edit]
  skip_before_action :authenticate_user!, :only => [:new, :create]

  def new
    @company = Company.new
    @company.build_address
    @company.employees.build
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to new_user_session_path
      flash[:notice] = "You will receive an email with instructions for how to confirm your email address in a few minutes."
    else
      render :'new'
    end
  end

  def update
    if !params[:page]
      params[:page] = 1
    end
    @company = Company.find(params[:id])
 
   if @company.update(company_params)
      redirect_to "#{companies_path}" + "?page=" + "#{params[:page]}"
   else
      flash[:error] = @company.errors.messages
      render :edit
   end
  end

  def destroy
    @company.destroy

    redirect_to companies_path
  end

  def index
    @companies = Company.all.order('created_at').page(params[:page]).per(5)
  end 

  
  private

  def company_params
    params.require(:company).permit(:name, :landline, :email, :subsidy,
      address_attributes: [:house_no, :pincode, :locality, :city, :state],
      employees_attributes: [:name, :email, :mobile_number, :password, :password_confirmation])
  end

  def load_company
    @company = Company.find(params[:id])
  end

end
