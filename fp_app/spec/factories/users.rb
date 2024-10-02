FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :other_user, class: User do
    email { "other_user@example.com" }
    password { "password" }
    password_confirmation { "password" }
    name { "Other User" }
  end
end
