FactoryBot.define do
  factory :user do
    nickname { Faker::Name.initials }
    first_name { '田畑' }
    last_name { '田畑' }
    first_name_kana { 'タバタ' }
    last_name_kana { 'タバタ' }
    email { Faker::Internet.email }
    password { 'test123' }
    password_confirmation { password }
    birthday { Faker::Date.birthday }
  end
end
