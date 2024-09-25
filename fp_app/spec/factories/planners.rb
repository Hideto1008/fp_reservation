FactoryBot.define do
  factory :planner do
    email { "test@example.com" }
    password { "password" }
    password_confirmation { "password" }
    name { "Test Planner" }
    icon_path { "/path/to/icon.png" }
    introduction { "This is a test planner." }
  end

  factory :other_planner, class: Planner do
    email { "other@example.com" }
    password { "password" }
    password_confirmation { "password" }
    name { "Other Planner" }
    icon_path { "/path/to/other_icon.png" }
    introduction { "This is another planner." }
  end
end
