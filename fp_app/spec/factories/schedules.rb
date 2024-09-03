FactoryBot.define do
    factory :schedule do
      planner_id { 1 }
      started_at { Time.parse("2024-09-30 17:00:00") }  
      is_available { true }
    end
  end
  