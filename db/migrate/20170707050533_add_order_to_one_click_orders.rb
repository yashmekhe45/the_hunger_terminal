class AddOrderToOneClickOrders < ActiveRecord::Migration[5.0]
  def change
    add_reference :one_click_orders, :order, foreign_key: true
  end
end