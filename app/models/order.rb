class Order < ApplicationRecord

  validates :date, :total_cost, :user, :company,:status, :terminal, presence: true
  validates :total_cost, numericality: { greater_than: 0 }
  validates :status, inclusion: {in: ORDER_STATUS}
  validates :user_id, uniqueness: { scope: :date }
  validate :valid_date?
  validate :can_be_created, :is_empty?, on: :create
  # validate :can_be_updated?, on: :update  
  belongs_to :user
  belongs_to :company
  belongs_to :terminal
  has_many :order_details, dependent: :destroy, inverse_of: :order

  after_initialize :set_date
  before_validation :set_discount

  accepts_nested_attributes_for :order_details

  def self.daily_orders(t_id,c_id)
    self.
      joins(:user,:order_details).
      where('orders.date' => Date.today,'orders.terminal_id' => t_id, 'orders.company_id' => c_id,
        'orders.status' => ['pending','review']).
      select('orders.id','users.name AS emp_name',
        'order_details.menu_item_name AS menu,quantity').
      order("users.name ASC")
  end

  def self.menu_details(t_id,c_id)
    self.
      joins(:order_details).
      where('orders.date'=> Date.today,'orders.terminal_id' => t_id,
        'orders.company_id'=> c_id,'orders.status' => ['pending','review']).
      group('order_details.menu_item_name').
      select('order_details.menu_item_name AS menu,sum(quantity) AS quantity')
  end

  def self.update_status(t_id,c_id)
    @orders = Order.where('orders.date' => Date.today, 
      'orders.terminal_id' => t_id, 'orders.company_id' => c_id)
    Order.where('orders.date' => Date.today,
      'orders.terminal_id' => t_id, 'orders.company_id' => c_id).update_all(:status => "placed")
    @employees =  @orders.
                    joins(:user).
                    pluck('users.email AS email')
    @employees.each do |emp|
      OrderMailer.send_mail_to_employees(emp).deliver_later
    end
  end

  # def self.find_employees(t_id,c_id)
  #   self.
  #     joins(:user).
  #     where('orders.date' => Date.today, 'orders.terminal_id' => t_id,
  #      'orders.company_id' => c_id).
  #     select('users.email as email')
  # end

  private

    # needs to be evaluated
    def valid_date?
      errors.add(:date, "can't be in the past") if !date.blank? and date < Date.today
    end

    def can_be_created?
      current_time = Time.now
      start_time = Time.parse "12 AM"
      end_time = Time.parse "11 PM"
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

    def set_discount
      a = self.company.subsidy
      b = self.total_cost
      self.discount = [a, (a*b)/100].min
      self.status = 'pending'
    end 
end
 
