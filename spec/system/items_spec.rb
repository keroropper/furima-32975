require 'rails_helper'

RSpec.describe "商品出品", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
  end

  context '商品を出品できるとき' do
    it 'ログインしたユーザーは商品を出品できる' do
      #ログインする
      sign_in(@user)
      #商品出品ページへのリンクがあることを確認する
        expect(page).to have_content('出品する')
      #商品出品ページへ移動する
        visit new_item_path
      #必要な情報を入力する
        fill_in 'item[image]', with: @item.image
        fill_in 'item[text]', with: @item.text
        fill_in 'item[describe]', with: @item.describe
        select "2", :from => "item-category"
        select "2", :from => "item-sales-status"
        select "2", :from => "item-shipping-fee-status"
        select "2", :from => "item-prefecture"
        select "2", :from => "item-scheduled-delivery"
        fill_in 'item[price]', with: @item.price
      #出品するとItemモデルのカウントが１上がることを確認する
        find{
          expect('input[name="commit"]')
        }.click to change { Item.count }.by(1)
      #トップページへ遷移する
        expect(current_path).to eq root_path
      #トップページには先ほど出品した内容の商品が存在することを確認する（画像）
        expect(page).to have_selector("カエルの画像.png']")
      #トップページには先ほど出品した内容の発送費支払い方法が存在することを確認する（テキスト）
    end
  end
  context '商品を出品できないとき' do
    it 'ログインしていないユーザーは商品出品ページへ遷移できない' do
      #トップページに遷移する
        visit root_path
      #商品出品ページへのリンクがあることを確認する
        expect(page).to have_content('出品する')
      #商品出品ページへの遷移リンクをクリックする
        click_on ('出品する')
      #ログインページへ移動することを確認する
      expect(current_path).to eq "/users/sign_in"
    end
  end
end
