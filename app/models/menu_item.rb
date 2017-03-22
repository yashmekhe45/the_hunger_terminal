class MenuItem < ApplicationRecord

  validates :name,:price, presence: true
  validates :price, numericality: { greater_than: 0 } 
  validates :veg, inclusion: { in: [false, true] }
  validates :name, uniqueness: { scope: :terminal_id , case_sensitive: false}
  validates :available, inclusion: {in: [true, false]}

  has_many :order_details
  belongs_to :terminal

  #before_validation :is_valid_day?
  
end
