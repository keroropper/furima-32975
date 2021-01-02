require 'rails_helper'

RSpec.describe '商品出品', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
  end

  context '商品を出品できるとき' do
    it 'ログインしたユーザーは商品を出品できる' do
      # ログインする
      sign_in(@user)
      # 商品出品ページへのリンクがあることを確認する
      expect(page).to have_content('出品する')
      # 商品出品ページへ移動する
      visit new_item_path
      # 必要な情報を入力する
      image_path = Rails.root.join('public/images/カエルの画像.png')
      attach_file('item[image]', image_path)
      fill_in 'item[text]', with: @item.text
      fill_in 'item[describe]', with: @item.describe
      find("#item-category").find("option[value='2']").select_option
      find("#item-sales-status").find("option[value='2']").select_option
      find("#item-shipping-fee-status").find("option[value='2']").select_option
      find("#item-prefecture").find("option[value='2']").select_option
      find("#item-scheduled-delivery").find("option[value='2']").select_option
      fill_in 'item[price]', with: @item.price
      # 出品するとItemモデルのカウントが１上がることを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { Item.count }.by(1)
      # トップページへ遷移する
      expect(current_path).to eq root_path
      # トップページには先ほど出品した内容の商品が存在することを確認する（画像）
      expect(page).to have_selector("img")
      # トップページには先ほど出品した内容の発送費支払い方法が存在することを確認する（テキスト）
    end
  end
  context '商品を出品できないとき' do
    it 'ログインしていないユーザーは商品出品ページへ遷移できない' do
      # トップページに遷移する
      visit root_path
      # 商品出品ページへのリンクがあることを確認する
      expect(page).to have_content('出品する')
      # 商品出品ページへの遷移リンクをクリックする
      click_on('出品する')
      # ログインページへ移動することを確認する
      expect(current_path).to eq '/users/sign_in'
    end
  end
end
