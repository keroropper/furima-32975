FactoryBot.define do
  factory :item do
    text { "アイウエオ" }
    describe { "かきくけこ" }
    category_id { 2 }
    status_id { 2 }
    charge_id { 2 }
    prefecture_id { 2 }
    day_id { 2 }
    price { 1000 }

    association :user
    after(:build) do |item|
      item.image.attach(io: File.open('public/images/カエルの画像.png'), filename: 'カエルの画像.png')
    end
  end
end
