class RenamePublicToOpenInDecksTable < ActiveRecord::Migration
  def up
    rename_column :decks, :public, :open
  end

  def down
    rename_column :decks, :open, :public
  end
end
