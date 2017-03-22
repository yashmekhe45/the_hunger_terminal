class OrderDetail < ApplicationRecord
  
  validates :status, :menu_item_id, presence: true
  validates :status, inclusion: {in: ORDER_DETAIL_STATUS}
  belongs_to :menu_item
  belongs_to :order
  
  after_initialize :assign_menu_item_details, if: :menu_item

  def assign_menu_item_details
    self.menu_item_name = menu_item.name
    self.menu_item_price = menu_item.price
    self.veg = menu_item.veg
    self.terminal_name = menu_item.terminal.name
    self.terminal = menu_item.terminal
  end

end
