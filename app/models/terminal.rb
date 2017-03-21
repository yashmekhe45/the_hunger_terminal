class Terminal < ApplicationRecord
  validates_with LandlineValidator
  validates :name, :landline ,:email, :active, presence: true
  validates :landline ,:email, uniqueness: true
  validates :landline ,length:{ is:12 } 

  has_many :menu_items,dependent: :destroy
  has_many :order
end
