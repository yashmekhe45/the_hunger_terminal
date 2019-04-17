class MenuItem < ApplicationRecord

  validates :name,:price, :terminal, presence: true
  #Below validation: There was a problem in showing error using simple form
  validates :active_days, presence: {message: "active days must be present"}
  validates :price, numericality: { greater_than: 0 } 
  validates :name, uniqueness: {scope: :terminal_id,  case_sensitive: false}

  has_many :order_details
  belongs_to :terminal

  before_validation :available_must_accept_boolean_only, :veg_must_accept_boolean_only, :remove_space
  before_save :titleize_name
  
  protected

  def available_must_accept_boolean_only
    if [true,false,'t', 'f', 'true','false',"1","0"].include?(self.available_before_type_cast) 
      return true
    else
      self.errors[:available] << 'This must be true or false.' 
      return false
    end
  end

  def veg_must_accept_boolean_only
    if [true,false,'t', 'f', 'true','false',1,0, 'TRUE', 'FALSE'].include?(self.veg_before_type_cast)
      return true
    else
      self.errors[:veg] << 'This must be true or false.' 
      return false
    end
  end

  def remove_space
    unless(self.name == nil || self.description == nil)
      self.name = name.squish
      self.description = description.squish
    end
  end

  def titleize_name
    self.name = name.titleize
  end

end
