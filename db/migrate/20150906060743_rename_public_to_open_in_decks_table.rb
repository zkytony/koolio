class RenamePublicToOpenInDecksTable < ActiveRecord::Migration
  def up
    rename_column :decks, :public, :open
  end

  def down
  end
end
