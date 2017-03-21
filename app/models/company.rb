class Company < ApplicationRecord
  
  validates_with LandlineValidator
  validates :name, :landline, presence: true
  validates :name, uniqueness:{case_sensitive: false}
  validates :landline, uniqueness: true
  validates :landline, length: {is: 12}

  validates :address, presence: true
  validate :create_company_admin, on: :create

  has_one :address, as: :location, dependent: :destroy
  has_many :employees, class_name: "User", dependent: :destroy
  has_many :orders, dependent: :destroy

  validates_presence_of :address

  accepts_nested_attributes_for :address, :employees

  before_validation :remove_space
  
  private 
    def remove_space
      #squish method is not for nil classes
      if(self.name == nil)
        return
      end
      self.name = name.squish
    end

    def create_company_admin
      self.employees.first.role = "company_admin"
      self.employees.first.is_active = true
    end
end
