class CompaniesController < ApplicationController
 
  def new
    @company = Company.new
    @company.build_address
    @company.employees.build
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to root_path
    else
      flash[:error] = @company.errors.messages
      render :'new'
    end
  end

  def update
    @company = Company.find(params[:id])
 
   if @company.update(company_params)
      redirect_to companies_path
   else
      flash[:error] = @company.errors.messages
      render :edit
   end
  end

  def edit

    @company = Company.find(params[:id])
    
  end

  def destroy
    @company = Company.find(params[:id])
    @company.destroy

    redirect_to companies_path
  end

  def index
    @companies = Company.all
  end 

  def show
    @company = Company.find(params[:id])
  
  end

  private

  def company_params
    params.require(:company).permit(:name, :landline, 
      address_attributes: [:house_no, :pincode, :locality, :city, :state],
      employees_attributes: [:name, :email, :mobile_number, :password])
  end

end
