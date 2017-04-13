class CompaniesController < ApplicationController

  skip_before_action :authenticate_user!, :only => [:new, :create]
  before_action :require_permission, only: [:show, :edit, :update, :delete, :get_order_details]
  before_action :load_company, only: [:update, :show, :destroy,:edit, :get_order_details, :set_order_details]

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
      flash[:errors] = @company.errors.messages
      render :'new'
    end
  end

  def update
    authorize! :update, @company
    @company = Company.find(params[:id])
   if @company.update_attributes(company_params)
      flash[:success] = "updated successfully!!"
      redirect_to root_path
   else
      flash[:error] = @company.errors.messages
   end
  end

  def destroy
    authorize! :delete, @company
    @company.destroy
    redirect_to companies_path
  end

  def index
    authorize! :company, @company
    @companies = Company.all.order('created_at').page(params[:page]).per(5)
  end 

  def get_order_details
  end

  
  private

  def company_params
    params.require(:company).permit(:name, :landline, :email, :subsidy, :start_ordering_at, 
      :review_ordering_at, :end_ordering_at,
      address_attributes: [:house_no, :pincode, :locality, :city, :state],
      employees_attributes: [:name, :email, :mobile_number, :password, :password_confirmation])
  end

  def load_company
    @company = Company.find(params[:id])
  end

  def require_permission
    if current_user != Company.find(params[:id]).employees.find_by(role: "company_admin")
      flash[:error] = "You are not authorized to access it!!"
      redirect_to vendors_path
    end
  end

end
