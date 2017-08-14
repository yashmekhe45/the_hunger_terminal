class OneClickOrder < ApplicationRecord
  has_secure_token

  validates :user, :order, presence: true

  belongs_to :user
  belongs_to :order

  def self.nullify_tokens
    OneClickOrder.destroy_all
  end
end
