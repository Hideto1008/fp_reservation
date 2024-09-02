FactoryBot.define do
    factory :schedule do
      planner_id { 1 }
      started_at { Time.zone.parse("2024-09-30 17:00:00") }  # JST で午後5時
      is_available { false }
    end
  end
  