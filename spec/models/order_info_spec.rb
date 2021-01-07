require 'rails_helper'

RSpec.describe OrderInfo, type: :model do
  before(:all) do
    @item = FactoryBot.create(:item)
    @user = FactoryBot.create(:user)
  end
  before(:each) do
    @info = FactoryBot.build(:order_info, item_id: @item.id, user_id: @user.id)
    # sleep(0.1)
  end



    describe '商品購入機能' do
    context '商品を購入できるとき' do
      it 'building_nameが記載されていなくても保存できる' do
        @info.building_name = ''
        expect(@info).to be_valid
      end
      it '全ての値が記入されているとき、購入できる' do
        expect(@info).to be_valid
      end
      it 'phone_numberは11桁以内であること（09012345678となる）' do
        @info.phone_number = '09012345678'
        expect(@info).to be_valid
      end
    end
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
        it 'phone_numberは11桁以内であること' do
          @info.phone_number = 123456789123456
          @info.valid?
          expect(@info.errors.full_messages).to include("Phone number Input correctly")
        end
        it 'tokenが空では登録できないこと' do
          @info.token = nil
          @info.valid?
          expect(@info.errors.full_messages).to include("Token can't be blank")
        end
        it 'user_idが空では登録できないこと' do
          @info.user_id = nil
          @info.valid?
          expect(@info.errors.full_messages).to include("User can't be blank")
        end
        it 'item_idが空では登録できないこと' do
          @info.item_id = nil
          @info.valid?
          expect(@info.errors.full_messages).to include("Item can't be blank")
        end
      end
    end
end
