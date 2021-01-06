FactoryBot.define do
  factory :order_info do
    post_code { "176-0021" }
    prefecture_id { 2 }
    city { '練馬区' }
    house_number { 5 - 4 - 11 }
    building_name { "マンション" }
    phone_number { 88_084_722_448 }
    token { 'test' }
  end
end
