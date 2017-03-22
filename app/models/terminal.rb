class Terminal < ApplicationRecord
  validates_with LandlineValidator
  validates :name, :landline , presence: true
  validates :landline ,:email, uniqueness: true
  validates :landline ,length:{ is:12 } 
  has_many :menu_items,dependent: :destroy
  accepts_nested_attributes_for :menu_items, allow_destroy: true 
  belongs_to :company
  mount_uploader :image, ImageUploader
  has_many :order
end
