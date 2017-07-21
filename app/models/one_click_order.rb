class OneClickOrder < ApplicationRecord
  has_secure_token

  validates :user, :order, presence: true

  belongs_to :user
  belongs_to :order

  def self.nullify_todays_tokens
    todays_date = Time.now.utc.to_date.strftime("%Y-%m-%d")
    one_click_orders = OneClickOrder.where("DATE(created_at) = ?", todays_date)
    one_click_orders.update_all(token: nil)
  end
end
