class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :user, index: true, foreign_key: true
      t.string :action
      t.string :trackable_type
      t.integer :trackable_id

      t.timestamps null: false
    end
    add_index :activities, [:trackable_type, :trackable_id, :action]
    add_index :activities, [:user_id, :trackable_type, :trackable_id, :action], name: "by_U_type_id_action"
  end
end
