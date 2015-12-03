class AddLikesToComments < ActiveRecord::Migration
  def change
    add_column :comments, :likes, :integer, :default => 0
  end
end
