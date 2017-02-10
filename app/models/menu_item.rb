class MenuItem < ApplicationRecord
  validates :name,:price, presence: true
  validates :price, numericality: { greater_than: 0 } 
  validates :veg, inclusion: { in: [true, false] }
  validates :name, uniqueness: { case_sensitive: false }
  belongs_to :terminal
end
