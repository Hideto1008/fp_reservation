FactoryBot.define do
  factory :appointment do
    user_id { 1 }
    planner_id { 1 }
    schedule_id { 1 }
    reserved_at { Time.parse("2024-09-30 17:00:00") }
    status { "reserved" }
  end
end
