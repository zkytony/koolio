class DropFollowingTable < ActiveRecord::Migration
  def change
    drop_table :followings
  end
end
