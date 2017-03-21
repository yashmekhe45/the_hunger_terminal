class OrderDetail < ApplicationRecord
 validates :status, inclusion: {in: ORDER_DETAIL_STATUS}

  belongs_to :menu_item
  belongs_to :order
 end
