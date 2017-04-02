class CompaniesController < ApplicationController

 
  before_action :load_company, only: [:update, :show, :destroy,:edit, :get_order_details, :set_order_details]
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
      flash[:errors] = @company.errors.messages
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

  def get_order_details
  end

  def set_order_details
    
    subsidy = params[:subsidy_val]
    start_ordering_at = Time.zone.parse params[:start_ordering_at_val]
    review_ordering_at = Time.zone.parse params[:review_ordering_at_val]
    end_ordering_at = Time.zone.parse params[:end_ordering_at_val]
    if @company.update(subsidy: subsidy, start_ordering_at: start_ordering_at, review_ordering_at:
      review_ordering_at, end_ordering_at: end_ordering_at)
      flash[:success] = "Order details successfully updated"
      redirect_to company_terminals_path(params[:id])
   else
      render :get_order_details
      flash[:error] = @company.errors.messages
   end

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

end
