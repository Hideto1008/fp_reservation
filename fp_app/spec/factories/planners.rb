FactoryBot.define do
  factory :planner do
    email { "test@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
