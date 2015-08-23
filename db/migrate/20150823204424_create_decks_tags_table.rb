class CreateDecksTagsTable < ActiveRecord::Migration
  def change
    create_table :decks_tags do |t|
      t.integer :deck_id
      t.integer :tag_id

      t.timestamps null: false
    end
    add_index :decks_tags, :deck_id
    add_index :decks_tags, :tag_id
    add_index :decks_tags, [:deck_id, :tag_id], unique: true
  end
end
