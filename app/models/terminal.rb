class Terminal < ApplicationRecord
  
  validates_with LandlineValidator
  validates_presence_of :email, message: "Emailid cant be blank"
  validates :name, :landline ,presence: true
  validates :landline ,uniqueness: { scope: :company_id }
  validates :landline ,length: { is: 11 }
  validates_format_of :email,with: Devise.email_regexp, message: "Invalid email format."
 
  has_many :menu_items, dependent: :destroy
  has_many :orders
  belongs_to :company

  mount_uploader :image, ImageUploader

  before_validation :remove_space
  
  private 
    
  def remove_space
    #squish method is not for nil classes
    if(self.name == nil)
      return
    end
    self.name = name.squish
  end

  def self.daily_terminals(c_id)
    self.
      joins(:orders).
      where('orders.date' => Date.today,'orders.company_id' => c_id).
      group('terminals.id').
      select('terminals.name,terminals.min_order_amount,terminals.id,
       sum(total_cost) AS total')
  end

end
