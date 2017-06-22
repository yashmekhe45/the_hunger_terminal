FactoryGirl.define do
  factory :terminal_extra_charge do
    daily_extra_charge {40}
    date {Time.zone.today}

    association :company
    association :terminal
    
  end
end
