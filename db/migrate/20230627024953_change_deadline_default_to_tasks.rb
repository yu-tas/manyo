class ChangeDeadlineDefaultToTasks < ActiveRecord::Migration[6.1]
  def change
    change_column_default :tasks, :deadline, -> { 'CURRENT_TIMESTAMP' }
  end
end
