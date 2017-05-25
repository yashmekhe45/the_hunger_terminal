class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable
  
  # devise :timeoutable, :timeout_in => 3.days

  validates_with MobileNoValidator
  validates :name, :mobile_number, :role, :email, presence: true
  validates :mobile_number, length: {is: 10}
  validates_presence_of :company_id , :if => :is_employee? 
  validates :role, inclusion: {in: USER_ROLES}
  validates :is_active, inclusion: {in: [true, false, 't','f', 'true','false']}, :unless => :is_super_admin?
  validates :mobile_number, uniqueness: { scope: :company_id}
  validates :email, uniqueness: {scope: :company_id}

  belongs_to :company
  has_many :orders, dependent: :destroy

  before_validation :not_a_string , :remove_space

  def active_for_authentication?  
    super && is_active  
  end

  def remove_space
    if(self.name == nil || self.mobile_number == nil|| self.email == nil||self.role == nil)
      return
    end
    self.name = name.squish
    self.mobile_number = mobile_number.squish
    self.email = email.squish
    self.role = role.squish 
  end

  def is_employee?
    self.role == "employee"
  end


  def is_super_admin?
    self.role == "super_admin"
  end

  def not_a_string

    if [true,false,'t', 'f', 'true','false',1,0].include?(self.is_active_before_type_cast) 
      return true
    else
      self.errors[:is_active] << 'This must be true or false.' 
      return false
    end
  end

  def self.employee_report(c_id)
    self.
      joins(:orders).
      where('company_id'=> c_id,'orders.status' => 'confirmed').
      where('orders.created_at' => Time.now.beginning_of_month-1.day..Time.now.midnight + 1.day).
      group('users.id').
      select('users.name,users.id,sum(orders.total_cost)AS total,sum(orders.discount)AS subsidy').
      order('users.id')
  end

  def self.employees_todays_orders_report(c_id)
    self.
      joins(:orders).
      where('company_id'=> c_id).
      where('orders.created_at >=?',Time.now.beginning_of_day).
      where('orders.status'=>'confirmed').
      select('users.name, users.id, orders.total_cost AS total, orders.discount AS subsidy').
      order('users.id')
  end

  def self.employee_last_month_report(c_id, month_back_date)
    self.
      joins(:orders).
      where('company_id'=> c_id).
      where('orders.created_at' => 1.month.ago.beginning_of_month-1.day..1.month.ago.end_of_month+1.day).
      where('orders.status'=>'confirmed').
      group('users.id').
      select('users.name,users.id,sum(orders.total_cost)AS total,sum(orders.discount)AS subsidy').
      order('users.id')
  end

  def self.employee_individual_report(c_id, user_id)
      self.joins(:orders).
      where('orders.company_id' => c_id).
      where('orders.user_id' => user_id).
      where('orders.created_at' => 1.month.ago.beginning_of_month-1.day..1.month.ago.end_of_month+1.day).
      where('orders.status' => 'confirmed').
      select('users.name,users.id,orders.created_at,orders.id,orders.total_cost,orders.discount')
  end

  def self.import(file, company_id)
    # spreadsheet = Roo::Spreadsheet.open(file.path)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      employee_record = User.find_by(email: row["email"])|| new

      # Mobile number is taking float values from Excel file
      row["mobile_number"] = row["mobile_number"].to_i
      employee_record.attributes = row.to_h
      employee_record.update_attributes("role" => "employee", "is_active" => true, "password" => Devise.friendly_token.first(8), "company_id" => company_id)
      if employee_record.valid?
        employee_record.save!
      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.csv' then Roo::CSV.new(file.path)
    when '.xls' then Roo::Excel.new(file.path)
    when '.xlsx' then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

end
