class AddActivationInfoToUsers < ActiveRecord::Migration
  def up
    add_column :users, :activation_digest, :string
    add_column :users, :activated_at, :datetime
  end
  
  def down
    remove_column :users, :activation_digest
    remove_column :users, :activated_at
  end
end
