require 'rails_helper'

RSpec.describe OrderInfo, type: :model do
  before do
    @info = FactoryBot.build(:order_info)
  end

  describe '商品購入機能' do
    context '商品を購入できないとき' do
      it 'post_codeが空だと購入できない' do
        @info.post_code = nil
        @info.valid?
        expect(@info.errors.full_messages).to include("Post code can't be blank", 'Post code Input correctly')
      end
      it 'post_codeにはハイフンが必要であること' do
        @info.post_code = '5555555'
        @info.valid?
        expect(@info.errors.full_messages).to include('Post code Input correctly')
      end
      it 'prefecture_idが1だと購入できない' do
        @info.prefecture_id = 1
        @info.valid?
        expect(@info.errors.full_messages).to include('Prefecture Select')
      end
      it 'cityが空だと購入できない' do
        @info.city = ''
        @info.valid?
        expect(@info.errors.full_messages).to include("City can't be blank")
      end
      it 'house_numberが空だと購入できない' do
        @info.house_number = ''
        @info.valid?
        expect(@info.errors.full_messages).to include("House number can't be blank")
      end
      it 'phone_numberが空だと購入できない' do
        @info.phone_number = ''
        @info.valid?
        expect(@info.errors.full_messages).to include("Phone number can't be blank", 'Phone number Half-width number')
      end
      it 'phone_numberにハイフンは不要であること' do
        @info.phone_number = '090-9999-9999'
        @info.valid?
        expect(@info.errors.full_messages).to include('Phone number Half-width number')
      end
      it 'tokenが空では登録できないこと' do
        @info.token = nil
        @info.valid?
        expect(@info.errors.full_messages).to include("Token can't be blank")
      end
      it 'tokenが間違っていると登録できないこと' do
        @info.token = 'test'
        @info.valid?
        expect(@info.errors.full_messages).to include('Post code Input correctly')
      end
    end
  end
end
