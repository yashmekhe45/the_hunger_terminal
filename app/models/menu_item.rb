class MenuItem < ApplicationRecord
  validates :name,:price, presence: true
  validates :price, numericality: { greater_than: 0 } 
  validates :veg, inclusion: { in: [false, true] }
  validates :name, uniqueness: { scope: :terminal_id , case_sensitive: false}
  belongs_to :terminal
end
