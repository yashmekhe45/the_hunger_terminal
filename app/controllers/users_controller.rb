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
      # redirect_to company_users_path
    else
      p @user.errors
      flash[:error]=  @user.errors.messages
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
    p params
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
      flash.now[:error]= @user.errors.messages
      if(@user.role == "company_admin")
        render :edit_company_admin
      else
        redirect_to company_users_path(params[:company_id],:page=>params[:page])
      end
    end
  end



  def import
    if !params[:file]
      flash[:error] = "Please select a CSV file."
      redirect_to company_users_path(params[:company_id])
    else
      valid_header =  ["name","email","mobile_number"]
      $INVALID_USER_CSV = nil
      @check_user = User.new(name:"dummy",email: "dummy@dummy.com", mobile_number: "+919999999999",is_active: false, 
        company_id: 1111,role: "employee", password: "dummy123")
      if params[:file].content_type == 'text/csv'
        users_csv = File.open(params[:file].path)
        users_data = CSV.parse(users_csv,headers:true)
        if users_data.headers == valid_header
          users_data.each do |user_row|
           
            next if user_row.to_a == valid_header
            user_hash = user_row.to_h 
            if !user_hash.empty?
              user = @company.employees.build(name: user_hash["name"],email: user_hash["email"], 
                mobile_number: user_hash["mobile_number"],is_active: true, role: "employee",
                password: Devise.friendly_token.first(8))
              if user.valid?
                user.save
              else
                CSV.open($INVALID_USER_CSV="public/#{@company.name}-invalid-records-#{Date.today}.csv","a+") do |csv|
                  user_row << user.errors.messages
                  csv << user_row
                end
                @check_user = user
              end
            end
          end
          if @check_user.valid?
            flash.now[:success] = "all users added through csv data"
            redirect_to company_users_path(params[:company_id])
          else
            flash.now[:notice] = "You have some invalid records.Correct it and upload it again"
          end
        else
          flash.now[:error] = "invalid headers in your csv."
        end
      else
        flash.now[:error] = "invalid type of file please upload csv with valid headers"
      end
    end
  end

  def search
    search_value = params[:search_value].downcase
   
    if search_value
      @users = @company.employees.where(role: "employee").where("lower(name) like ? or
       lower(email) like ?", "%#{search_value}%","%#{search_value}%").all.
       order('created_at').page(params[:page]).per(2)
      if @users.empty?
        p "No record found"
        flash[:error] = "No record found"
        redirect_to company_users_path(params[:company_id])
      end
    else
      render "index"
    end
  end

  def download
    if "#{Rails.root}/#{$INVALID_USER_CSV}"
      send_file("#{Rails.root}/#{$INVALID_USER_CSV}")
    else
      flash[:error] = "No invalid record"
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

  def load_company
    @company = Company.find(params[:company_id])  
  end
end
