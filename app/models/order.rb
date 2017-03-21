class Order < ApplicationRecord
  validates :date, :total_cost, :user, :company,:status, :terminal, presence: true
  validates :total_cost, numericality: { greater_than: 0 }
  validates :status, inclusion: {in: ORDER_STATUS}
  validates :user_id, uniqueness: { scope: :date }
  validate :valid_date?
  validate :can_be_created?, :is_empty?, on: :create
  # validate :can_be_updated?, on: :update

  belongs_to :user
  belongs_to :company
  belongs_to :terminal
  has_many :order_details, dependent: :destroy, inverse_of: :orde
  
  belongs_to :user
  belongs_to :company
  

  after_initialize :set_date

  accepts_nested_attributes_for :order_details

  private

    # needs to be evaluated
    def valid_date?
      errors.add(:date, "can't be in the past") if !date.blank? and date < Date.today
    end

    def can_be_created?
      current_time = Time.now
      start_time = Time.parse "12 AM"
      end_time = Time.parse "11 AM"
      day = current_time.wday
      if day%7 != 0 and day%7 != 6
        if !current_time.between?(start_time, end_time)
          errors.add(:base,"order cannot be created after 11 AM")
        end
      else
        errors.add(:base,"order cannot be created on saturday and sunday")
      end
    end

    def set_date
      self.date = Date.today
    end

    def is_empty?
      if self.order_details.any? == false
        errors.add(:base,"order shold have minimum one menu item")
      end
    end
end
