class AddUserRefToTasks < ActiveRecord::Migration[6.1]
    def change
      User.reset_column_information
      first_user = User.first
  
      # assign the first user to all tasks
      Task.all.each do |task|
        task.update_columns(user_id: first_user.id) 
      end
  
      add_reference :tasks, :user, null: false, foreign_key: true
    end
end
