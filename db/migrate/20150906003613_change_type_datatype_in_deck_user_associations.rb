class ChangeTypeDatatypeInDeckUserAssociations < ActiveRecord::Migration
  def up
    change_column :deck_user_associations, :type, :string
  end

  def down
    change_column :deck_user_associations, :type, :integer
  end
end
