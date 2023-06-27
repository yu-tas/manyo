require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  let!(:task){FactoryBot.create(:task, title: 'task1_title', content: 'task1_content')}
  let!(:second_task){ FactoryBot.create(:second_task, title: 'task2_title', content: 'task2_content')}
    

  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in 'Title', with: 'task_title'
        fill_in 'Content', with: 'task_content'
        click_button '登録する' 
        expect(page).to have_content 'task_title'
        expect(page).to have_content 'task_content'
      end
    end
  end
  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        visit tasks_path
        expect(page).to have_content 'task1_title'
        expect(page).to have_content 'task1_content'
        expect(page).to have_content 'task2_title'
        expect(page).to have_content 'task2_content'
      end
    end

    # テスト内容を追加で記載する
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        new_task = FactoryBot.create(:task, title: 'new_task_title', content: 'new_task_content') 
        tasks = Task.all.order(created_at: :desc)
        expect(tasks.first).to eq new_task 
      end
    end
  end
  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        visit task_path(task)
        expect(page).to have_content 'task1_title'
        expect(page).to have_content 'task1_content' 
      end
    end
  end
end