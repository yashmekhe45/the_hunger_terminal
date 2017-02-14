class Company < ApplicationRecord
  # include ActiveModel::Validations

  validates_with LandlineValidator
  validates :name, :landline, presence: true
  validates :name, uniqueness:{case_sensitive: false}
  validates :landline, uniqueness: true
  validates :landline, length: {is: 12}
  validates :address, presence: true
  validates :employees, presence: true

  has_one :address, dependent: :destroy, as: :location
  has_many :employees , class_name: "User", dependent: :destroy
  before_validation :remove_space
  def remove_space
    #squish method is not for nil classes
    if(self.name == nil)
      return
    end
    self.name = name.squish
  end
  
end
