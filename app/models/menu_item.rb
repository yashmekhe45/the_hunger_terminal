class MenuItem < ApplicationRecord

  validates :name,:price, :active_days, :available, presence: true
  validates :price, numericality: { greater_than: 0 } 
  validates :veg, inclusion: { in: [false, true] }
  validates :name, uniqueness: { scope: :terminal_id , case_sensitive: false}
  validates :available, inclusion: {in: [true, false]}
  has_many :order_details
  belongs_to :terminal

  # after_save  :order_has_available_menu_item
  # before_validation :is_valid_day?
  
  protected

  def order_has_available_menu_item
    if !self.available

      @orders_details = self.order_details.all.where(created_at: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day))
      # @distinct_orders = @orders_details.select('distinct on (order_id) *')
      @orders_details.each do |order_details|
        order_details.status = 'unavailable'
        order_details.save!
        order = order_details.order
        order.status = 'review'
        order.save!
      end 

      # @distinct_orders.each do |order_details|
      #   order_details.order.status = 'review'
      #   order_details.order.save!
      # end  
    end
  end

end
