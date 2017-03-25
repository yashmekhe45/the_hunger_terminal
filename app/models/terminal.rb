class Terminal < ApplicationRecord
  
  # validates_with LandlineValidator
  # validates :name, :landline ,presence: true
  # validates :landline ,uniqueness: true
  # validates :landline ,length: { is: 10 }

  has_many :menu_items, dependent: :destroy
  has_many :orders
  belongs_to :company

  mount_uploader :image, ImageUploader

  def self.daily_terminals(c_id)
    self.
      joins(:orders).
      where('orders.date' => Date.today,'orders.company_id' => c_id).
      group('terminals.id').
      select('terminals.name,terminals.min_order_amount,terminals.id,
       sum(total_cost) AS total')
  end
end
