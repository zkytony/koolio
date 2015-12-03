class AddLikesToCards < ActiveRecord::Migration
  def change
    add_column :cards, :likes, :integer, :default => 0
  end
end
