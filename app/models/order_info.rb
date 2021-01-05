class OrderInfo
  include ActiveModel::Model
  attr_accessor :post_code, :prefecture_id, :city, :house_number, :building_name, :phone_number, :token, :user_id, :item_id
  # 上記のカラム名を全て使用することができる

  with_options presence: true do
    validates :post_code, format: { with: /\A\d{3}[-]\d{4}\z/, message: 'Input correctly' }
    validates :prefecture_id, numericality: { other_than: 1, message: 'Select' }
    validates :city
    validates :house_number
    validates :phone_number, numericality: { only_integer: true, message: 'Half-width number' } 
    validates :token
  end

  def save
    order = Order.create(item_id: item_id, user_id: user_id)
    Address.create(post_code: post_code, prefecture_id: prefecture_id, city: city, 
      house_number: house_number, building_name: building_name, phone_number: phone_number, order_id: order.id)
  end

end