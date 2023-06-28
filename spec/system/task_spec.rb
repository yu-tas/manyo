require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  let!(:task){FactoryBot.create(:task, title: 'task1', content: 'task1_content', deadline: 2.days.from_now, created_at: 2.days.ago)}
  let!(:second_task){FactoryBot.create(:task, title: 'task2', content: 'task2_content', deadline: 1.day.from_now, created_at: 1.days.ago)}
  let!(:third_task){FactoryBot.create(:task, title: 'task3', content: 'task3_content', deadline: 3.days.from_now, created_at: 3.days.ago)}
    

  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in 'Title', with: 'task_title'
        fill_in 'Content', with: 'task_content'
        fill_in 'Deadline', with: 3.days.from_now
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
        task_list = all('.task_row')
        expect(task_list[0]).to have_content 'task2_content'
        expect(task_list[1]).to have_content 'task1_content'
        expect(task_list[2]).to have_content 'task3_content'
      end
    end

    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        new_task = FactoryBot.create(:task, title: 'new_task_title', content: 'new_task_content', deadline: 3.days.from_now) 
        visit tasks_path
        task_list = all(".task_row")
        expect(task_list[0]).to have_content 'new_task_title'
        expect(task_list[0]).to have_content 'new_task_content'
      end
    end
    context '終了期限でソートする場合' do
      it '終了期限が速いタスクが一番上に表示される' do
        visit tasks_path
        click_link '終了期限でソートする'
        sleep 1.0
        task_list = all(".task_row")
        expect(task_list[0]).to have_content 'task2'
        expect(task_list[1]).to have_content 'task1'
        expect(task_list[2]).to have_content 'task3'
      end
    end
  end
  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        visit task_path(task)
        expect(page).to have_content 'task1'
        expect(page).to have_content 'task1_content' 
      end
    end
  end
end