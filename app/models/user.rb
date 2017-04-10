class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  
  devise :timeoutable, :timeout_in => 3.days

  validates_with MobileNoValidator
  validates :name, :mobile_number, :role, :email, presence: true
  validates :mobile_number, length: {is: 10}
  validates_presence_of :company_id , :if => :is_employee? 
  validates :role, inclusion: {in: USER_ROLES}
  validates :is_active, inclusion: {in: [true, false, 't','f', 'true','false']}, :unless => :is_super_admin?
  validates :mobile_number, uniqueness: { scope: :company_id}

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
      where('company_id'=> c_id).
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
      where('orders.created_at' => 1.month.ago.beginning_of_month..1.month.ago.end_of_month).
      where('orders.status'=>'confirmed').
      group('users.id').
      select('users.name,users.id,sum(orders.total_cost)AS total,sum(orders.discount)AS subsidy').
      order('users.id')
  end

  def employee_individual_report(c_id, user_id)
      # self.joins(:orders).
      # where('company_id' => c_id).
  end

end
