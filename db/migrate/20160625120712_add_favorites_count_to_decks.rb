class AddFavoritesCountToDecks < ActiveRecord::Migration
  def up
    add_column :decks, :favorites_count, :integer, :default => 0
  end

  def down
    remove_column :decks, :favorites_count
  end
end
