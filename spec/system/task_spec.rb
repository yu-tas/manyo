require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:task){FactoryBot.create(:task, title: 'task1', content: 'task1_content', status: :未着手, deadline: 2.days.from_now, created_at: 2.days.ago, priority: :low, user: user)}
  let!(:second_task){FactoryBot.create(:task, title: 'task2', content: 'task2_content', status: :着手中, deadline: 1.day.from_now, created_at: 1.days.ago, priority: :medium, user: user)}
  let!(:third_task){FactoryBot.create(:task, title: 'task3', content: 'task3_content', status: :完了, deadline: 3.days.from_now, created_at: 3.days.ago, priority: :high, user: user)}

  

  describe '検索機能' do
    before do
      visit new_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'
    end  
    context 'タイトルであいまい検索をした場合' do
      it "検索キーワードを含むタスクで絞り込まれる" do  #1
        visit tasks_path
        fill_in 'task_title', with: 'task1'
        sleep 3.0
        click_button '検索'
        expect(page).to have_content 'task1'
      end
    end
    context 'ステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do  #2
        sleep 3
        visit tasks_path
        select '着手中', from: 'task[status]'
        click_button '検索'
        expect(page).to have_content 'task2'
        expect(page).not_to have_content 'task1'
        expect(page).not_to have_content 'task3'
      end
    end
    context 'タイトルのあいまい検索とステータス検索をした場合' do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do  #3
        sleep 3
        visit tasks_path
        fill_in "task[title]", with: 'task'
        select '着手中', from: 'task_status'
        click_button '検索'
        expect(page).to have_content 'task2'
      end
    end
  end

  describe '新規作成機能' do
  context 'タスクを新規作成した場合' do
    it 'タスクを新規登録するとき、ステータスも登録ができる' do #4
      visit new_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      binding.pry
      click_button 'Log in'
      binding.pry
      visit new_task_path
      sleep 5.0
      fill_in 'task[title]', with: 'task_title'
      fill_in 'task[content]', with: 'task_content'
      fill_in 'task[deadline]', with: 3.days.from_now
      select '着手中', from: 'task[status]'
      sleep 3.0
      click_button '登録する' 
      expect(page).to have_content 'task_title'
    end
  end
end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do  #5
        visit new_session_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Log in'
        visit tasks_path
        sleep 15
        task_list = all('.task_row')
        sleep 1.0
        expect(task_list[0]).to have_content 'task2_content'
        expect(task_list[1]).to have_content 'task1_content'
        expect(task_list[2]).to have_content 'task3_content'
      end
    end

    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do  #6
        visit new_session_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Log in'
        new_task = FactoryBot.create(:task, title: 'new_task_title', content: 'new_task_content', deadline: 3.days.from_now, status: :完了, priority: :low, user: user) 
        visit tasks_path
        task_list = all(".task_row")
        expect(task_list[0]).to have_content 'new_task_content'
      end
    end
    context '終了期限でソートする場合' do
      it '終了期限が速いタスクが一番上に表示される' do  #7
        visit new_session_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        binding.pry
        click_button 'Log in'
        sleep 10
        binding.pry
        visit tasks_path
        click_link '終了期限でソートする'
        sleep 5.0
        task_list = all(".task_row")
        expect(task_list[0]).to have_content 'task2_content'
        expect(task_list[1]).to have_content 'task1_content'
        expect(task_list[2]).to have_content 'task3_content'
      end
    end
    context '優先順位でソートする場合' do
      it '優先順位が低いタスクが一番上に表示される' do  #8
        visit new_session_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Log in'
        visit tasks_path
        sleep 3.0
        click_link '優先順位でソートする'
        sleep 3.0
        task_list = all(".task_row")
        expect(task_list[0]).to have_content 'task1_content'
        expect(task_list[1]).to have_content 'task2_content'
        expect(task_list[2]).to have_content 'task3_content'
      end
    end
    context 'タスク一覧のページネーションが機能する場合' do
      before do
        visit new_session_path
        sleep 3
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Log in'
        create_list(:task, 15, user: user) 
        visit tasks_path
      end
    
      it '1ページ目には10個のタスクが表示される' do  #9
        sleep 5.0
        task_list = all(".task_row")
        expect(task_list.size).to eq 10
      end
    
      it '2ページ目には5個のタスクが表示される' do  #10
        click_link 'Next'  
        sleep 5.0
        task_list = all(".task_row")
        expect(task_list.size).to eq 8
      end
    end 
  end
  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do  #11
      it '該当タスクの内容が表示される' do
        visit new_session_path
        sleep 3
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Log in'
        binding.pry
        visit task_path(task)
        sleep 3
        expect(page).to have_content 'task1'
        expect(page).to have_content 'task1_content' 
      end
    end
  end
end