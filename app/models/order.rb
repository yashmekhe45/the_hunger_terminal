class Order < ApplicationRecord
  
  validates :date, :total_cost, :status, :terminal_id, presence: true
  validates :total_cost, numericality: { greater_than: 0 }
  validates :status, inclusion: {in: ORDER_STATUS}
  validate :date_cannot_be_in_the_past
  validate :order_can_be_created?, on: :create
  before_validation :set_discount 

  

  belongs_to :user
  belongs_to :company
  belongs_to :terminal
  has_many :order_details,dependent: :destroy
  accepts_nested_attributes_for :order_details
  def date_cannot_be_in_the_past
    errors.add(:date, "can't be in the past") if !date.blank? and date < Date.today
  end

  def order_can_be_created?
    hour = Time.now.hour
    if hour > 9 and hour < 14
      errors.add(:date,"order cannot be created between 9 AM to 2 PM")
    end
  end

  def set_discount
    a = self.company.subsidy
    b = self.total_cost
    self.discount = [a, (a*b)/100].min
    self.status = 'pending'
  end 
end
 