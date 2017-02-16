class CompaniesController < ApplicationController

  def new
    @company=Company.new
    @company.employees.build
    @company.build_address  
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

  private
    def company_params
      params.require(:company).permit(:name, :landline, 
        address_attributes: [:house_no, :pincode, :locality, :city, :state],
        employees_attributes: [:name, :email, :mobile_number, :password])
    end
end
