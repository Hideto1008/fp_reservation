FactoryBot.define do
  factory :planner do
    sequence(:email) { |n| "planner#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    name { "Test Planner" }
    icon_path { "/path/to/icon.png" }
    introduction { "This is a test planner." }
  end
end
