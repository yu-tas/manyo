class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.text :title, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
