class Terminal < ApplicationRecord
  validates_with LandlineValidator
  validates :name, :landline ,presence: true
  validates :landline ,uniqueness: true
  validates :landline ,length:{ is:12 }
  has_many :menu_items
end
