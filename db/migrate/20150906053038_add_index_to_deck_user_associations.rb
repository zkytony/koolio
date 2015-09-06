class AddIndexToDeckUserAssociations < ActiveRecord::Migration
  def change
    add_index :deck_user_associations, [:deck_id, :user_id], unique: true
  end
end
