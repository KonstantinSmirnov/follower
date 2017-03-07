# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email 'testuser@example.com'
    password 'password'
    password_confirmation 'password'
  end
end
