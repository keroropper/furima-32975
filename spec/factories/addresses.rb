FactoryBot.define do
  factory :address do
    post_code { 176-0021 }
    prefecture_id { 2 }
    city { "練馬区" }
    house_number { 5-4-11 }
    phone_number { 88084722448 }
  end
end
