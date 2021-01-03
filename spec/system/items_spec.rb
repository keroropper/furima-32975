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
      page.execute_script "window.scrollBy(0,10000)"               #画面を下までスクロールする
      expect {
        find('input[name="commit"]').click
      }.to change { Item.count }.by(1)
      # トップページへ遷移する
      expect(current_path).to eq root_path
      # トップページには先ほど出品した内容の商品が存在することを確認する（画像）
      expect(all(".item-img")[0]).to have_selector("img")
      # トップページには先ほど出品した内容の発送費支払い方法が存在することを確認する（テキスト）
      expect(page).to have_content("着払い(購入者負担)")
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

RSpec.describe '商品編集機能', type: :system do
  before do
    @item1 = FactoryBot.create(:item)
    @item2 = FactoryBot.create(:item)
  end

  context '商品を編集できるとき' do
    it 'ログイン状態の出品者は、商品情報を編集できる' do
      # @item1を出品したユーザーでログインする
      visit new_user_session_path
      fill_in 'user[email]', with: @item1.user.email
      fill_in 'user[password]', with: @item1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 詳細ページへ遷移する
      visit item_path(@item1)
      # 詳細ページに編集ボタンがあることを確認する
      expect(page).to have_content('商品の編集')
      # 編集ページへ遷移する
      visit edit_item_path(@item1)
      # 既に、商品情報がフォームに入っていることを確認する
      expect(
        find('#item-name').value
      ).to eq "#{@item1.text}"
      expect(
        find('#item-info').value
      ).to eq "#{@item1.describe}"
      expect(
        find('#item-category').value
      ).to eq "#{@item1.category_id}"
      expect(
        find('#item-sales-status').value
      ).to eq "#{@item1.status_id}"
      expect(
        find('#item-shipping-fee-status').value
      ).to eq "#{@item1.charge_id}"
      expect(
        find('#item-prefecture').value
      ).to eq "#{@item1.prefecture_id}"
      expect(
        find('#item-scheduled-delivery').value
      ).to eq "#{@item1.day_id}"
      expect(
        find('#item-price').value
      ).to eq "#{@item1.price}"
      # 商品情報を編集する
      image_path = Rails.root.join('public/images/ウユニ塩湖.jpg')
      attach_file('item[image]', image_path)
      fill_in 'item[text]', with: "#{@item1.text}+編集"
      fill_in 'item[describe]', with: "#{@item1.describe}+編集"
      find("#item-category").find("option[value='3']").select_option
      find("#item-sales-status").find("option[value='3']").select_option
      find("#item-shipping-fee-status").find("option[value='3']").select_option
      find("#item-prefecture").find("option[value='3']").select_option
      find("#item-scheduled-delivery").find("option[value='3']").select_option
      fill_in 'item[price]', with: @item1.price + 1000
      # 編集してもItemモデルのカウントは変わらないことを確認する
      page.execute_script "window.scrollBy(0,10000)"               #画面を下までスクロールする
      expect {
        find('input[name="commit"]').click
      }.to change { Item.count }.by(0)
      # 商品詳細ページへ移動する
      visit item_path(@item1)
      # 編集された商品情報が表示されていることを確認する
      expect(page).to have_selector("img")
      expect(page).to have_content("#{@item1.text}+編集")
      expect(page).to have_content("#{@item1.describe}+編集")
      expect(page).to have_content("メンズ")
      expect(page).to have_content("未使用に近い")
      expect(page).to have_content("送料込み(出品者負担)")
      expect(page).to have_content("青森県")
      expect(page).to have_content("2~3日で発送")
      expect(page).to have_content("#{@item1.price + 1000}")
    end
    it 'ログイン状態の出品者は、商品情報を編集でき、画像を変更せずに編集してもエラーが起きないことを確認する' do
        # @item1を出品したユーザーでログインする
        visit new_user_session_path
        fill_in 'user[email]', with: @item1.user.email
        fill_in 'user[password]', with: @item1.user.password
        find('input[name="commit"]').click
        expect(current_path).to eq root_path
        # 詳細ページへ遷移する
        visit item_path(@item1)
        # 詳細ページに編集ボタンがあることを確認する
        expect(page).to have_content('商品の編集')
        # 編集ページへ遷移する
        visit edit_item_path(@item1)
        # 既に、商品情報がフォームに入っていることを確認する
        expect(
          find('#item-name').value
        ).to eq "#{@item1.text}"
        expect(
          find('#item-info').value
        ).to eq "#{@item1.describe}"
        expect(
          find('#item-category').value
        ).to eq "#{@item1.category_id}"
        expect(
          find('#item-sales-status').value
        ).to eq "#{@item1.status_id}"
        expect(
          find('#item-shipping-fee-status').value
        ).to eq "#{@item1.charge_id}"
        expect(
          find('#item-prefecture').value
        ).to eq "#{@item1.prefecture_id}"
        expect(
          find('#item-scheduled-delivery').value
        ).to eq "#{@item1.day_id}"
        expect(
          find('#item-price').value
        ).to eq "#{@item1.price}"
        # 商品情報を編集する
        fill_in 'item[text]', with: "あああいいい"
        fill_in 'item[describe]', with: "うううええええ"
        find("#item-category").find("option[value='3']").select_option
        find("#item-sales-status").find("option[value='3']").select_option
        find("#item-shipping-fee-status").find("option[value='3']").select_option
        find("#item-prefecture").find("option[value='3']").select_option
        find("#item-scheduled-delivery").find("option[value='3']").select_option
        fill_in 'item[price]', with: @item1.price + 1000
        # 編集してもItemモデルのカウントは変わらないことを確認する
        page.execute_script "window.scrollBy(0,10000)"               #画面を下までスクロールする
        expect {
          find('input[name="commit"]').click
        }.to change { Item.count }.by(0)
        # 商品詳細ページへ移動する
        visit item_path(@item1)
        # 画像を選択せずに編集して詳細ページに戻っても、元々の画像が表示されていること
        expect(page).to have_selector("img")
    end
  end
  context '商品情報を編集できない時' do
    it 'ログインしたユーザーは、自分以外が出品した商品の編集画面に遷移できない' do
      # @item1を出品したユーザーでログインする
      visit new_user_session_path
      fill_in 'user[email]', with: @item1.user.email
      fill_in 'user[password]', with: @item1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 詳細ページへ遷移する
      visit item_path(@item2)
      # 編集ページへ遷移するボタンがないことを確認する
      expect(page).to have_no_content("商品の編集")
    end
    it 'ログインしていないと商品編集画面には遷移できない' do
      #トップページにいる
      visit root_path
      # 詳細ページへ移動する
      visit item_path(@item1)
      # 編集ページへ遷移するボタンがないことを確認する
      expect(page).to have_no_content("商品の編集")
    end
  end
end

RSpec.describe '商品削除機能', type: :system do
  before do
    @item1 = FactoryBot.create(:item)
    @item2 = FactoryBot.create(:item)
  end

  context '商品を削除できるとき' do
    it 'ログイン状態の出品者は、商品情報を削除できる' do
      # @item1を出品したユーザーでログインする
      visit new_user_session_path
      fill_in 'user[email]', with: @item1.user.email
      fill_in 'user[password]', with: @item1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 詳細ページへ遷移する
      visit item_path(@item1)
      # 詳細ページに削除ボタンがあることを確認する
      expect(page).to have_content('削除')
      # 商品を削除するとレコードの数が一つ減ることを確認する
      expect {
        find_link("削除", href: item_path(@item1)).click
      }.to change { Item.count }.by(-1)
      # トップ画面に遷移することを確認する
      visit root_path
      # トップページに、商品の画像が存在しないことを確認する
      expect(all(".item-img")[0]).to have_no_selector("img")
      # トップページに、商品名が存在しないことを確認する
      expect(all(".item-name")[0]).to have_no_selector("#{@item1.text}")
    end
  end

  context '商品情報を削除できない時' do
    it 'ログインしたユーザーは、自分以外が出品した商品の削除ができない' do
      # @item1を出品したユーザーでログインする
      visit new_user_session_path
      fill_in 'user[email]', with: @item1.user.email
      fill_in 'user[password]', with: @item1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 詳細ページへ遷移する
      visit item_path(@item2)
      # 削除ボタンがないことを確認する
      expect(page).to have_no_content("削除")
    end
    it 'ログインしていないと商品詳細ページに削除ボタンがない' do
      #トップページにいる
      visit root_path
      # 詳細ページへ移動する
      visit item_path(@item1)
      # 削除ボタンがないことを確認する
      expect(page).to have_no_content("削除")
    end
  end
end
