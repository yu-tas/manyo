# 「FactoryBotを使用します」という記述
FactoryBot.define do
  # 作成するテストデータの名前を「task」とします
  # （実際に存在するクラス名と一致するテストデータの名前をつければ、そのクラスのテストデータを自動で作成します）
  factory :task do
    title { 'task_title' }
    content { 'task_content' }
    deadline { Time.now + 7.days }
    status { 0 }  # 未着手
    priority { 2 }
  end
  # 作成するテストデータの名前を「second_task」とします
  # （存在しないクラス名の名前をつける場合、オプションで「このクラスのテストデータにしてください」と指定します）
  factory :second_task, class: Task do
    title { 'second_task_title' }
    content { 'second_task_content' }
    deadline { Time.now + 7.days }
    status { 0 }  # 未着手
    priority { 2 }
  end

  factory :third_task, class: Task do
    title { 'third_task_title' }
    content { 'third_task_content' }
    deadline { Time.now + 7.days }
    status { 0 }  # 未着手
    priority { 2 }
  end
end
