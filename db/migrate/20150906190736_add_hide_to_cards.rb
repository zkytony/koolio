class AddHideToCards < ActiveRecord::Migration
  def up
    add_column :cards, :hide, :boolean, default: false
  end

  def down
    remove_column :decks, :hide
  end
end

