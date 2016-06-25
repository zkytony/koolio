class CreateCategorizations < ActiveRecord::Migration
  def change
    create_table :categorizations do |t|
      t.integer :category_id
      t.integer :deck_id

      t.timestamps null: false
    end
    add_index :categorizations, :deck_id
    add_index :categorizations, :category_id
    add_index :categorizations, [:deck_id, :category_id], unique: true
  end
end
