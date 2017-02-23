class Order < ApplicationRecord
  belongs_to :user
  belongs_to :company

  validates :date, :total_cost, presence: true
  validates :total_cost, numericality: { greater_than: 0 }
  validate :date_cannot_be_in_the_past
  # validate :order_can_be_created?, on: :create

  def date_cannot_be_in_the_past
    errors.add(:date, "can't be in the past") if !date.blank? and date < Date.today
  end

  # def order_can_be_created?
  #   hour = Time.now.hour
  #   if hour > 9 and hour < 14
  #     errors.add(:date,"order cannot be created between 9 AM to 2 PM")
  #   end
  # end
end
