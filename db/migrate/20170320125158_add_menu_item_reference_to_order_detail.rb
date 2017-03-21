class AddMenuItemReferenceToOrderDetail < ActiveRecord::Migration[5.0]
  def change
    add_reference :order_details, :menu_item, foreign_key: true, index: true
  end
end
