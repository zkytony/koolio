class CreateLikeCards < ActiveRecord::Migration
  def change
    create_table :like_cards do |t|
      t.integer :user_id
      t.integer :card_id

      t.timestamps null: false
    end
    add_index :like_cards, :user_id
    add_index :like_cards, :card_id
    add_index :like_cards, [:user_id, :card_id], unique: true
  end
end
