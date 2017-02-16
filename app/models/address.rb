class Address < ApplicationRecord

  validates :house_no, :pincode, :locality, :city, :state, presence: true
  validates :pincode, numericality:{only_integer:true}
  validates :pincode , length: {is: 6}
  belongs_to :location, polymorphic: true
    
  before_validation :remove_space
  def remove_space
    if(self.house_no == nil || self.locality == nil || 
      self.city == nil || self.state == nil)
      return
    end
    self.house_no = house_no.squish
    self.locality = locality.squish
    self.city = city.squish
    self.state = state.squish
  end
end
