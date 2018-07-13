class Order < ApplicationRecord

  validates :date, :total_cost, :user, :company,:status, :terminal, presence: true
  validate :can_be_created?, :is_empty?, on: :create
  validates :total_cost, numericality: { greater_than: 0 }
  validates :status, inclusion: {in: ORDER_STATUS}
  validates :user_id, uniqueness: { scope: :date }
  validate :valid_date?, on: :create
  validate :valid_day?, on: :create


  scope :confirmed, -> { where(status: 'confirmed') }

  belongs_to :user
  belongs_to :company
  belongs_to :terminal
  has_many :order_details, dependent: :destroy, inverse_of: :order,autosave: true
  has_many :one_click_orders, dependent: :destroy

  before_validation :set_discount, :calculate_tax
  
  accepts_nested_attributes_for :order_details, allow_destroy: true, reject_if: proc { |attributes| attributes['quantity'].to_i == 0 }

  def self.daily_orders(terminal_id, company_id)
    self.
      joins(:user,:order_details).
      where('orders.date' => Time.zone.today,'orders.terminal_id' => terminal_id,
        'orders.company_id' => company_id).
      select('orders.id','users.name AS emp_name',
        'order_details.menu_item_name AS menu, quantity', 'order_details.id as detail_id', 'orders.status').
      order("users.name ASC")
      # 'orders.status' => ['pending','review','placed']
  end

  #complete the below functionality: for getting all the terminal specific today's orders
  def self.get_terminal_specific_orders(terminal_id,company_id)
    self.
      joins(:user).
      where('orders.date' => Time.zone.today, 'orders.terminal_id' => terminal_id,
        'orders.company_id' => company_id, 'orders.status' => 'confirmed').
      select('orders.id', 'orders.total_cost','users.id')
  end

  def self.employees_daily_order_detail_report(company_id)
    self.
      joins(:user,:order_details,:terminal).
      where('orders.date' => Time.zone.today, 'orders.company_id' => company_id).
      group('orders.id,orders.terminal_id,users.name,order_details.menu_item_name,order_details.quantity,terminals.name').
      select('orders.id','users.name AS emp_name',
        'order_details.menu_item_name AS menu, quantity,terminals.name AS vendor').
      order("users.name ASC")
  end

  def self.menu_details(terminal_id, company_id)
    self.
      joins(:order_details).
      where('orders.date'=> Time.zone.today,'orders.terminal_id' => terminal_id,
        'orders.company_id'=> company_id, 'orders.status' => ['pending', 'review']).
      group('order_details.menu_item_name').
      select('order_details.menu_item_name AS menu, sum(quantity) AS quantity')
  end

  def self.update_status(order_details)
    # @orders = Order.where('orders.date' => Time.zone.today, 
    #   'orders.terminal_id' => t_id, 'orders.company_id' => c_id)
    order_ids = order_details.pluck(:id).uniq
    orders = Order.where(:id => order_ids)
    orders.update_all(:status => "placed")
  end

  def self.confirm_all_placed_orders(terminal_id, company_id, order_details)
    order_ids = order_details.pluck(:id).uniq
    orders = Order.where(:id => order_ids)
    orders.update_all(:status => "confirmed")
    employee_ids =  orders.
                    joins(:user).
                    pluck('users.id')
    employee_ids.each do |employee_id|
      SendEmployeeOrderMailJob.perform_later(employee_id)
    end
  end

  def self.cancel_all_placed_orders(terminal_id, company_id, order_details)
    order_ids = order_details.pluck(:id).uniq
    orders = Order.where(id: order_ids)
    employee_ids =  orders.
                    joins(:user).
                    pluck('users.id')
    recommended_terminals = Terminal.where(active: true, company_id: company_id).order(:min_order_amount)[0..2]
    employee_ids.each do |employee_id|
    SendEmployeeCancelMailJob.perform_now(employee_id, recommended_terminals)
    Order.where(id: order_ids).destroy_all
    end
  end

  def self.get_all_orders_status(terminal_id)
    where(date: Time.zone.today, terminal_id: terminal_id).pluck(:status)
  end

  def create_one_click_order(employee_id)
    self.one_click_orders.create(user_id: "#{employee_id}")
  end
  
  private

    def valid_date?
      if !date.blank?
        if date < Time.zone.today
          errors.add(:date, "can't be in the past")
        elsif date > Time.zone.today
          errors.add(:date, "can't be in the future")
        end    
      end
    end

    def valid_day?
      today =  Time.zone.today
      sunday = Time.zone.today.end_of_week
      saturday = Time.zone.today.end_of_week.prev_day
      if today == sunday || today == saturday
        errors.add(:base, "order cannot be created on saturday or sunday")
      end
    end

    def can_be_created?
      current_time = Time.zone.now.strftime('%H:%M:%S')
      start_time = self.company.start_ordering_at.strftime('%H:%M:%S')
      end_time = self.company.end_ordering_at.strftime('%H:%M:%S')

      if !(current_time >= start_time and current_time <= end_time)
        start_time = self.company.start_ordering_at.strftime('%I:%M %p')
        end_time = self.company.end_ordering_at.strftime('%I:%M %p')
        errors.add(:base,"order cannot be created or updated before #{start_time} and after #{end_time}")
      end
    end


    def is_empty?
      if self.order_details.any? == false
        errors.add(:base,"order shold have minimum one menu item")
      end
    end

    def calculate_tax
      if self.terminal == nil
        order_tax = 0.0
      else
        order_tax = self.terminal.tax.to_f
      end
      total_cost = self.total_cost
      self.tax = ((order_tax*total_cost)/100).round if total_cost?
    end

    def set_discount
      if self.company == nil
        subsidy = 0.0
      else
        subsidy = self.company.subsidy
      end
      total_cost = self.total_cost
      if total_cost == nil
        total_cost = 0.0
      end
      self.discount = [subsidy, (subsidy*total_cost)/100].min
    end 
end
 
