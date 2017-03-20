class OrderDetail < ApplicationRecord
  belongs_to :menu_item
  belongs_to :order
  belongs_to :terminal
  after_initialize :assign_menu_item_details, if: :menu_item

  def assign_menu_item_details
    self.menu_item_name = menu_item.name
    self.menu_item_price = menu_item.price
    self.veg = menu_item.veg
    self.terminal_name = menu_item.terminal.name
    self.terminal = menu_item.terminal
  end
end
