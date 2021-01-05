FactoryBot.define do
  factory :order_info do
    post_code { 176 - 0o021 }
    prefecture_id { 2 }
    city { '練馬区' }
    house_number { 5 - 4 - 11 }
    phone_number { 88_084_722_448 }
    token { 'sk_test_e969cb059a76239fb21514c5' }
  end
end
