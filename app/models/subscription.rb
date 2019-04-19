class Subscription < ApplicationRecord
  belongs_to :user

  validates :endpoint, :auth_key, :p256dh_key, presence: true
end
