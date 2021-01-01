require 'rails_helper'

RSpec.describe 'ユーザー新規登録機能', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context '新規登録できるとき' do
    it '正しい情報を入力すればユーザー新規登録ができ、トップページに移動する' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページに遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'user[nickname]', with: @user.nickname
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      fill_in 'user[password_confirmation]', with: @user.password_confirmation
      fill_in 'user[first_name]', with: @user.first_name
      fill_in 'user[last_name]', with: @user.last_name
      fill_in 'user[first_name_kana]', with: @user.first_name_kana
      fill_in 'user[last_name_kana]', with: @user.last_name_kana
      # find('option[value="1930"]').select_option
      select '1930', from: 'user_birthday_1i'
      select '1', from: 'user_birthday_2i'
      select '1', from: 'user_birthday_3i'
      # サインアップボタンを押すとユーザーモデルのカウントが１上がることを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { User.count }.by(1)
      # トップページへ遷移する
      expect(current_path).to eq root_path
      # ユーザーのニックネーム、ログアウトボタンが表示されていることを確認する
      expect(page).to have_content(@user.nickname)
      expect(page).to have_content('ログアウト')
      # サインアップページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録できずに、新規登録ページへ戻ってくる' do
      # トップページへ移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'user[nickname]', with: ''
      fill_in 'user[email]', with: ''
      fill_in 'user[password]', with: ''
      fill_in 'user[password_confirmation]', with: ''
      fill_in 'user[first_name]', with: ''
      fill_in 'user[last_name]', with: ''
      fill_in 'user[first_name_kana]', with: ''
      fill_in 'user[last_name_kana]', with: ''
      # サインアップボタンを押しても、、モデルのカウントは上がらないことを確認する
      expect  do
        find('input[name="commit"]').click
      end.to change { User.count }.by(0)
      # 新規登録ページへ戻ってくることを確認する
      expect(current_path).to eq '/users'
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context 'ログインができるとき' do
    it '保存されている情報と合致すればログインできる' do
      # トップページへ移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ移動する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # ユーザーのニックネーム、ログアウトボタンが表示されていることを確認する
      expect(page).to have_content(@user.nickname)
      expect(page).to have_content('ログアウト')
      # サインアップページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ログインができないとき' do
    it '保存されているユーザーの情報と合致しないとログインできない' do
      # トップページへ移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ移動する
      visit new_user_session_path
      fill_in 'user[email]', with: ''
      fill_in 'user[password]', with: ''
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページへ戻されることを確認する
      expect(current_path).to eq '/users/sign_in'
    end
  end
end
