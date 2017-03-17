class Terminal < ApplicationRecord
  validates_with LandlineValidator
  validates :name, :landline ,presence: true
  validates :landline ,uniqueness: true
  validates :landline ,length: { is: 10 }

  has_many :menu_items,dependent: :destroy
  accepts_nested_attributes_for :menu_items, allow_destroy: true 
end
