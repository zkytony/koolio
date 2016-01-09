class AddResetInfoToUsers < ActiveRecord::Migration
  def up
    add_column :users, :reset_digest, :string
    add_column :users, :reset_at, :datetime
  end
  
  def down
    remove_column :users, :reset_digest
    remove_column :users, :reset_at
  end
end
