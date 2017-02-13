class Company < ApplicationRecord
  # include ActiveModel::Validations

  # validates_with LandlineValidator
  # validates :name, :landline, presence: true
  # # validates :name, uniqueness:{case_sensitive: false}
  # validates :landline, uniqueness: true

  # has_one :address, dependent: :destroy
  # has_many :users, as :employees, dependent: :destroy
end
