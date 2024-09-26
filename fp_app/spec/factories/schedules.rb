FactoryBot.define do
  factory :schedule do
    planner
    started_at { Time.current+1.day }
    is_available { false }
  end

  factory :schedule_with_appointments, parent: :schedule do
    planner
    started_at { Time.parse("2024-09-30 17:00:00") }
    is_available { true }
  end
end
