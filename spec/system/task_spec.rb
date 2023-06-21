require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  before do
    # あらかじめタスク一覧のテストで使用するためのタスクを二つ作成する
    FactoryBot.create(:task)
    FactoryBot.create(:second_task)
  end

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
        task = FactoryBot.create(:task, title: 'task_title', content: 'task_content')
        visit tasks_path
        expect(page).to have_content 'task_title'
        expect(page).to have_content 'task_content'
      end
    end
  end
  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        task = FactoryBot.create(:task, title: 'task_title', content: 'task_content')  
        visit task_path(task)
        expect(page).to have_content 'task_title'
        expect(page).to have_content 'task_content' 
      end
    end
  end
end