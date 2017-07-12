require 'securerandom'
FactoryGirl.define do
  factory :one_click_order do
    token {SecureRandom.hex}

    association :user
    association :order
  end
end
