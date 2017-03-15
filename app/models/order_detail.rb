class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :terminal

  validates :menu_item_name, :price, :total_price, presence: true
  validates :price, :total_price, numericality: { greater_than: 0 }
end
