class Terminal < ApplicationRecord  

  validates :name, :landline , :company_id, presence: true
  validates :landline ,uniqueness: { scope: :company_id,  message: "terminal landline should be unique in a company" }
  validates :landline ,length: { is: 11 }
  validates :min_order_amount, :payment_made, :current_amount, numericality: {greater_than_or_equal_to: 0 }
  validates :gstin ,length: { is: 15 } , :allow_blank => true
  validates_presence_of :gstin, :if => :tax?
  validates :tax ,numericality: { greater_than_or_equal_to: 0 , less_than_or_equal_to: 100 }, :allow_blank => true
  validates :active, inclusion: {in: [true, false]}  
  validates_with LandlineValidator

  # validates_format_of :email,with: Devise.email_regexp, message: "Invalid email format." 
  has_many :menu_items, dependent: :destroy
  has_many :orders
  has_many :terminal_reports
  has_many :terminal_extra_charges
  belongs_to :company

  mount_uploader :image, ImageUploader

  before_validation :remove_space, :active_must_accept_boolean_only
  before_save :titleize_name

  def ordered_amount
    Order.where(status: 'pending',terminal_id: id).sum(:total_cost)
  end

  def confirmation_possibility
    return 100 if min_order_amount <= ordered_amount
    100 * ordered_amount / min_order_amount
  end

  def cancel_terminal_orders
    orders = Order.where(terminal_id: id)
    employees = User.where(id: orders.pluck(:user_id))
    orders.destroy_all
    recommended_terminals = company.top_recommended_terminals
    company.update(end_ordering_at: TIME_EXTENTION.minutes.from_now)
    employees.each do |employee|
      OrderMailer.send_order_cancel_employees(
        employee.name,
        employee.email,
        recommended_terminals
      ).deliver_now
    end
  end

  def logo_url
    return self.image_url(:thumb) if image_url.present?
    ImageUploader.default_url
  end

  private 
    
  def remove_space
    #squish method is not for nil classes
    unless(self.name == nil)
      self.name = name.squish
    end
  end

  def active_must_accept_boolean_only
    if [true,false,'t', 'f', 'true','false',1,0].include?(self.active_before_type_cast) 
      return true
    else
      self.errors[:active] << 'This must be true or false.' 
      return false
    end
  end

  def self.daily_terminals(c_id)
    self.
      joins(:orders).
      where('orders.date' => Time.zone.today, 'orders.company_id' => c_id, 'orders.status' => ['placed', 'pending', 'confirmed']).
      group('terminals.id').
      select('terminals.name,terminals.min_order_amount,terminals.id,
      sum(orders.total_cost+orders.tax) AS total')
  end

  def self.all_terminals_last_month_reports(c_id)

    self.
      joins(:terminal_reports).
      where('terminals.company_id' => c_id).
      group('terminals.id').
      select('terminals.name,terminals.id,sum(terminal_reports.current_amount) AS total,
        sum(terminal_reports.payment_made) AS total_paid')
  end  

  def self.all_terminals_todays_orders_report(c_id)
    self.
      joins(:orders).
      where('orders.company_id' => c_id, 'orders.date' => Time.zone.today, 'terminals.company_id' => c_id, 'orders.status' => 'confirmed').
      group('terminals.id').
      select('terminals.name, terminals.id, sum(orders.total_cost+orders.tax) AS total')
  end

  def self.all_terminals_todays_order_details(c_id)
    self.
      joins(:orders => :order_details).
      where('orders.date' => Time.zone.today, 'terminals.company_id'=>c_id, 'orders.company_id' => c_id, 'orders.status' => 'confirmed').
      group('terminals.id','order_details.menu_item_name').
      select('terminals.name, order_details.menu_item_name, sum(order_details.quantity) AS quantity, sum(order_details.quantity * order_details.price) AS total').
      order('terminals.name')
  end

  def self.update_current_amount_of_terminal(t_id, c_id, todays_order_total)
    @company = Company.find(c_id)
    @terminal = @company.terminals.find(t_id)
    @terminal.current_amount = @terminal.current_amount + todays_order_total.to_f
    @terminal.payable = @terminal.current_amount - @terminal.payment_made
    @terminal.save!
    @terminal
  end

  def self.update_post_payment_details_of_terminal(t_id, c_id)
    @company =  Company.find c_id
    @terminal = @company.terminals.find t_id
    @terminal.payable = @terminal.payable - @terminal.payment_made
    if @terminal.payable <= 0
      @terminal.current_amount = 0
      @terminal.payment_made = -@terminal.payable
    else
      @terminal.current_amount = 0
      @terminal.payment_made = 0 
    end
    @terminal.save  
  end

  def self.save_last_payment_made_to_terminal(t_id, c_id)
    @company = Company.find c_id
    @terminal = @company.terminals.find t_id
    @terminal_last_payment = @terminal.terminal_reports.build(name: @terminal.name, 
      current_amount: @terminal.current_amount, payment_made: @terminal.payment_made,
      payable: @terminal.payable-@terminal.payment_made)
    @terminal_last_payment.save
  end

  def titleize_name
    self.name = name.titleize
  end

end
