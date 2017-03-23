class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable


  validates_with MobileNoValidator
  validates :name, :mobile_number, :role, :email, presence: true
  validates :mobile_number, length: {is: 13}
  validates :role, inclusion: {in: USER_ROLES}
  validates_presence_of :company_id, :if => :is_employee? 
  validates :is_active, inclusion: {in: [true, false, 't','f', 'true','false']}, :unless => :is_super_admin?
  validates :mobile_number, uniqueness: { scope: :company_id}
  before_validation :not_a_string , :remove_space

  belongs_to :company
  has_many :orders, dependent: :destroy

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

  def role?(base_role)
    p base_role.to_s
    USER_ROLES.index(base_role.to_s) <= USER_ROLES.index(role)
  end

end
