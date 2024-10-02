FactoryBot.define do
  factory :appointment do
    reserved_at { (Time.now.beginning_of_week + 1.week) + 12.hours }
    status { "reserved" }
  end
end
