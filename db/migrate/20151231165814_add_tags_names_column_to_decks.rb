class AddTagsNamesColumnToDecks < ActiveRecord::Migration
  def up
    add_column :decks, :tags_names, :string
  end

  def down
    remove_column :decks, :tags_names
  end
end
