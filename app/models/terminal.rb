class Terminal < ApplicationRecord
  validates :name, :landline ,presence: true
  validates :landline ,uniqueness: true
  has_many :menu_items
end
