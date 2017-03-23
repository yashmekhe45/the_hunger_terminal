class Terminal < ApplicationRecord
  
  validates_with LandlineValidator
  validates :name, :landline ,presence: true
  validates :landline ,uniqueness: { scope: :company_id }
  validates :landline ,length: { is: 10 }

  has_many :menu_items,dependent: :destroy
  has_many :order_details 
  has_many :menu_items,dependent: :destroy
  has_many :order
  belongs_to :company

  mount_uploader :image, ImageUploader
end
