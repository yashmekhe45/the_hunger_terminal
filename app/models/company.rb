class Company < ApplicationRecord
  
  validates_with LandlineValidator
  # validates :name, :landline, :email, :address, presence: true
  # validates :start_ordering_at, :review_ordering_at, :end_ordering_at,  presence: true
  validates :name, uniqueness:{case_sensitive: false}
  validates :landline, uniqueness: true
  validates :landline, length: {is: 11}
  validates :name, :address, presence: true
  validate :create_company_admin, on: :create
  validates_format_of :email,:with => Devise.email_regexp
  validates :subsidy, inclusion: { in: 0..100, message: "value must be between 0 to 100" }
  # validates :start_ordering_at, :review_ordering_at, :end_ordering_at, :subsidy,  presence: true

  has_one :address,  as: :location, dependent: :destroy
  has_many :employees , class_name: "User", dependent: :destroy
  has_many :terminals, dependent: :destroy
  has_many :orders, dependent: :destroy

  accepts_nested_attributes_for :address, :employees

  before_validation :remove_space

  def send_reminders
    unless weekend? 
      users = orders.where(date: Time.zone.today).pluck(:user_id)
      recipients = active_employees.where.not(id: users).pluck(:email, :name)
      end_time = end_ordering_at.strftime('%I:%M %p')
      recipients.each do |recipient|
        OrderMailer.send_place_order_reminder(recipient, end_time).deliver_now
      end
    end
  end

  private 

    def weekend?
      # find the weekday and check for sunday(0) and saturday(6)
      day = Time.zone.today.wday    
      (day % 7).in?([0, 6])
    end

    def active_employees
      self.employees.where(is_active: true)
    end

    def remove_space
      #squish method is not for nil classes
      if(self.name == nil)
        return
      end
      self.name = name.squish
    end

    def create_company_admin
      self.employees.first.role = "company_admin"
      self.employees.first.is_active = true
    end
end
