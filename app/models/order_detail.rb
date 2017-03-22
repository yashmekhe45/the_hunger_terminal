class OrderDetail < ApplicationRecord

  belongs_to :menu_item
  belongs_to :order
  after_initialize :assign_menu_item_details, if: :menu_item

  def assign_menu_item_details
    self.menu_item_name = menu_item.name
    self.price = menu_item.price
   
  end

  # validates :status, :menu_item_id, presence: true
  # validates :status, inclusion: {in: ORDER_DETAIL_STATUS}
end
