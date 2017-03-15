class Order < ApplicationRecord
  belongs_to :user
  belongs_to :company

  validates :date, :total_cost, :user, :company, presence: true
  validates :total_cost, numericality: { greater_than: 0 }
  validate :date_cannot_be_in_the_past
  validate :can_order_be_created?, on: :create

  after_initialize :set_date

  private
    def date_cannot_be_in_the_past
      errors.add(:date, "can't be in the past") if !date.blank? and date < Date.today
    end

    def can_order_be_created?
      current_time = Time.zone.now
      start_time = Time.zone.parse "9 AM"
      end_time = Time.zone.parse "2 PM"
      if current_time.between?(start_time, end_time)
        errors.add(:date,"order cannot be created between 9 AM to 2 PM")
      end
    end

    def set_date
      t = Time.parse "2 PM"
      if(Time.now >= t)
        self[:date] = Date.tomorrow
      else
        self[:date] = Date.today
      end
    end
end
