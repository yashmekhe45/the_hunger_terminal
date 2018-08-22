class OrderDetail < ApplicationRecord

  validates :status, :menu_item, :order, :menu_item_name, :price, presence: true
  validates :status, inclusion: {in: ORDER_DETAIL_STATUS}
  validates :price, numericality: { greater_than: 0 }
  validates :quantity, numericality: { greater_than: 0,less_than: 11 }

  belongs_to :menu_item
  belongs_to :order, inverse_of: :order_details

  before_validation :assign_menu_item_details, if: :menu_item

  def assign_menu_item_details
    self.menu_item_name = menu_item.name
    self.price = menu_item.price  
    self.status = 'available' 
  end

  def self.get_orders_for_one_click_ordering(employee_id)
    orders = order_ids = []
    #order_details is the array of hashes where key: OrderId and value: Array of arrays having menu_item_name and quantity
    order_details = OrderDetail.get_order_details(employee_id)
    unless order_details.empty?
      order_details.uniq!(&:values)
      order_details.take(3).each{|order_hash|  order_ids << order_hash.keys }
      order_ids.flatten!
      orders = OrderDetail.get_orders(order_ids)  
    end
    orders
  end

  private 

  def self.get_order_details(employee_id)
    joins(order: :terminal).
    select('DISTINCT ON (
      order_id,
      orders.terminal_id,
      menu_item_id,
      quantity) *, orders.terminal_id AS terminal_id').
    where(
      'orders.user_id': employee_id,
      'orders.status': :confirmed,
      terminals: {active: true}
    ).
    order('order_id desc').group_by(&:order_id).
    map {|order_id, order_detail| {
        order_id => order_detail.pluck(:menu_item_name, :quantity, :terminal_id)
      }
    }
  end

  def self.get_orders(order_ids)
    orders = []
    order_ids.each{ |order_id| orders << Order.find(order_id)}
    orders
  end
end
