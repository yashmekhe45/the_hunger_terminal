class OrderDetail < ApplicationRecord

  validates :status, :menu_item, :order, :menu_item_name, :price, presence: true
  validates :status, inclusion: {in: ORDER_DETAIL_STATUS}
  validates :price, numericality: { greater_than: 0 }

  belongs_to :menu_item
  belongs_to :order, inverse_of: :order_details
  
end
