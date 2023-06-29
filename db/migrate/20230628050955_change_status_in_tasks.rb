class ChangeStatusInTasks < ActiveRecord::Migration[6.0]
  def up
    # statusがnullのレコードにデフォルト値（ここでは0を例にします）を設定
    Task.where(status: nil).update_all(status: 0)

    # null: falseの制約を追加
    change_column_null :tasks, :status, false
  end

  def down
    # null: falseの制約を解除
    change_column_null :tasks, :status, true
  end
end

