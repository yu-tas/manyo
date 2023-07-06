FactoryBot.define do
  factory :user do
    name { "test_user" }
    email { "test_user@example.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { false }

    factory :admin_user do
      name { "admin_user" }
      email { "admin_user@example.com" }
      password { "password" }
      password_confirmation { "password" }
      admin { true }
    end
  end
end
