FactoryBot.define do
  factory :schedule do
    planner
    started_at { Time.current+1.day }
    is_available { false }
  end
end
