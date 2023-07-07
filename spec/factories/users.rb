FactoryBot.define do
  factory :user do
    name { "test_user" }
    email { "test_user@example.com" }
    password { "password" }
    password_confirmation { "password" }
    role { :general }

    factory :admin_user do
      name { "admin_user" }
      email { "admin_user@example.com" }
      password { "password" }
      password_confirmation { "password" }
      role { :admin }
    end
  end
end
