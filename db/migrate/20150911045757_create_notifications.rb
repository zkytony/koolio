class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true, foreign_key: true
      t.string :action
      t.string :notifier_type
      t.integer :notifier_id

      t.timestamps null: false
    end
    add_index :notifications, [:notifier_type, :notifier_id, :action]
    add_index :notifications, [:user_id, :notifier_type, :notifier_id, :action], name: "notification_by_user_type_id_action"
  end
end
