class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  has_one :order
  belongs_to :user
  has_one_attached :image
  belongs_to_active_hash :category
  belongs_to_active_hash :status
  belongs_to_active_hash :charge
  belongs_to_active_hash :prefecture
  belongs_to_active_hash :day

  with_options presence: true do
    validates :image
    validates :text
    validates :describe
    validates :category_id, numericality: { other_than: 1, message: 'Select' }  # ジャンルの選択が「--」の時は保存できないようにする
    validates :status_id, numericality: { other_than: 1, message: 'Select' }
    validates :charge_id, numericality: { other_than: 1, message: 'Select' }
    validates :prefecture_id, numericality: { other_than: 1, message: 'Select' }
    validates :day_id, numericality: { other_than: 1, message: 'Select' }
    validates :price, numericality: { only_integer: true, message: 'Half-width number' } # 半角数字のみを保存する。
    # validates :price, format: { with: /\A[0-9]+\z/, message: 'Half-width number' }
  end
  validates :price,
            numericality: { less_than_or_equal_to: 9_999_999, greater_than_or_equal_to: 300, message: 'Out of setting range' }
end
