class Item < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  with_options presence: true do
    validates :text
    validates :describe
    validates :category_id
    validates :status_id
    validates :charge_id
    validates :prefecture_id
    validates :day_id
    validates :price
    validates :image
  end
end
