class AddPublicToDecks < ActiveRecord::Migration
  def up
    add_column :decks, :public, :boolean, default: true
  end

  def down
    remove_column :decks, :public
  end
end
