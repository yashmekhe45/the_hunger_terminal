class Terminal < ApplicationRecord
  
  validates_with LandlineValidator
  # validates_presence_of :email, message: "Emailid cant be blank"
  validates :name, :landline ,presence: true
  validates :landline ,uniqueness: { scope: :company_id }
  validates :landline ,length: { is: 11 }
  validates :tax,numericality: { greater_than_or_equal_to: 0 }
  validates :min_order_amount, numericality: { greater_than_or_equal_to: 0 }
  # validates_format_of :email,with: Devise.email_regexp, message: "Invalid email format." 
  has_many :menu_items, dependent: :destroy
  has_many :orders
  has_many :terminal_reports
  has_many :terminal_extra_charges
  belongs_to :company

  mount_uploader :image, ImageUploader

  before_validation :remove_space
  
  private 
    
  def remove_space
    #squish method is not for nil classes
    unless(self.name == nil)
      self.name = name.squish
    end
  end

  def self.daily_terminals(c_id)
    self.
      joins(:orders).
      where('orders.date' => Time.zone.today, 'orders.company_id' => c_id, 'orders.status' => ['placed', 'pending', 'confirmed']).
      group('terminals.id').
      select('terminals.name,terminals.min_order_amount,terminals.id,
      sum(total_cost) AS total')
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
      select('terminals.name, terminals.id, sum(orders.total_cost) AS total')
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

end
