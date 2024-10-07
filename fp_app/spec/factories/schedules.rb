FactoryBot.define do
  factory :schedule do
    planner
    started_at { (Time.now.beginning_of_week + 1.week) + 13.hours }
    is_available { false }

    trait :reserved_schedule do
      started_at { (Time.now.beginning_of_week + 1.week) + 12.hours }
      is_available { true }
    end
  end
end
