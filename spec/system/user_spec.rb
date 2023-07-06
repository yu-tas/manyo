require 'rails_helper'
RSpec.describe User, type: :system do
  describe "ユーザ登録のテスト" do
    it "ユーザの新規登録ができること" do
      expect(FactoryBot.build(:user)).to be_valid
    end
  end

  describe "未ログイン時のアクセス制限のテスト" do
    context "タスク一覧画面にアクセスした場合" do
      before { visit tasks_path }

      it "ログイン画面にリダイレクトされること" do
        expect(current_path).to eq new_session_path
      end
    end
  end
  
describe "セッション機能のテスト" do
  before do
    @user = FactoryBot.create(:user)
    visit new_session_path
    fill_in 'Email', with: 'test_user@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Log in'
  end

  context "ログインができること" do
    it "ユーザー名が表示される" do
      expect(page).to have_content @user.name
    end
  end

  context "マイページへの遷移" do
    it "成功する" do
      visit user_path(@user)
      expect(page).to have_current_path(user_path(@user))
    end
  end

  context "一般ユーザが他人の詳細画面に飛ぶとタスク一覧画面に遷移すること" do
    let(:other_user) { FactoryBot.create(:user, email: 'other@example.com') }
    before { visit user_path(other_user) }
    it { expect(current_path).to eq tasks_path }
  end

  context "ログアウトができること" do
    before do
      click_link 'Logout'
    end
    it "ログイン画面にリダイレクトされる" do
      expect(page).to have_current_path(new_session_path)
    end
  end
end

    describe "管理画面のテスト" do
      let(:admin) { FactoryBot.create(:admin_user) }
      let(:user) { FactoryBot.create(:user) }
  
      context "管理ユーザは管理画面にアクセスできること" do
        before do
          visit new_session_path
          fill_in 'Email', with: admin.email
          fill_in 'Password', with: admin.password
          sleep 3.0
          click_button 'Log in'
          sleep 5.0
          visit admin_users_path
        end
        it { expect(current_path).to eq admin_users_path }
      end
  
      context "一般ユーザは管理画面にアクセスできないこと" do
				before do
					visit new_session_path
					fill_in 'Email', with: user.email
					fill_in 'Password', with: user.password
					click_button 'Log in'
				end
			
				it "リダイレクトされる" do
					sleep 1
					visit admin_users_path
					expect(page).to have_current_path(tasks_path)
				end
			end
			
  
      context "管理ユーザはユーザの新規登録ができること" do
				before do
					visit new_session_path
					fill_in 'Email', with: admin.email
					fill_in 'Password', with: admin.password
					click_button 'Log in'
					sleep 1
					visit new_admin_user_path
				end
			
				it "新規ユーザが作成される" do
					fill_in 'user_name', with: 'newuser'
					fill_in 'user_email', with: 'newuser@example.com'
					fill_in 'user_password', with: 'newpassword'
					fill_in 'user_password_confirmation', with: 'newpassword'
					click_button '登録する'
					sleep 1
					expect(User.where(email: 'newuser@example.com').exists?).to be true
				end
			end
			
      
      context "管理ユーザはユーザの詳細画面にアクセスできること" do
        before do
          visit new_session_path
          fill_in 'Email', with: admin.email
          fill_in 'Password', with: admin.password
          click_button 'Log in'
          sleep 10.0
          visit user_path(user)
        end
				it "詳細画面に表示されているユーザ名が正しいこと" do
					expect(page).to have_content user.name
				end
      end

      context "管理ユーザはユーザの編集画面からユーザを編集できること" do
        before do
          visit new_session_path
          fill_in 'Email', with: admin.email
          fill_in 'Password', with: admin.password
          click_button 'Log in'
          sleep 3.0
          visit edit_admin_user_path(user)
					sleep 3.0
          fill_in 'user_name', with: 'updateduser'
					fill_in 'user_email', with: 'updateduser@example.com'
					fill_in 'user_password', with: 'password'
					fill_in 'user_password_confirmation', with: 'password'
          click_button '更新する'
        end
        it { expect(user.reload.name).to eq 'updateduser' }
      end
      
      context "管理ユーザはユーザの削除ができること" do
				let!(:user) { User.create(name: 'Test User', email: 'test@example.com', password: 'password') }
				before do
					visit new_session_path
					fill_in 'Email', with: admin.email
					fill_in 'Password', with: admin.password
					click_button 'Log in'
					sleep 1
					visit admin_users_path
					accept_confirm do
					click_link '削除', href: admin_user_path(user)
					end
					sleep 1
				end
			
				it "ユーザ一覧から削除したユーザ名が消えていること" do
					expect(page).not_to have_content(user.name)
				end
			end			
    end
  end
  