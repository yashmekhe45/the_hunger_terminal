class Terminal < ApplicationRecord
  
  validates_with LandlineValidator
  validates :name, :landline ,presence: true
  validates :landline ,uniqueness: true
  validates :landline ,length: { is: 10 }

  has_many :menu_items, dependent: :destroy
  has_many :orders
  belongs_to :company

  mount_uploader :image, ImageUploader
end
