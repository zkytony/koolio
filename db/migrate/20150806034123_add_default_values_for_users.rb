class AddDefaultValuesForUsers < ActiveRecord::Migration
  # change column is not automatically reversible, therefore need up & down
  def up
    change_column :users, :activated, :boolean, :default => false
  end
  
  def down
    change_column :users, :activated, :boolean, :default => nil
  end
end
