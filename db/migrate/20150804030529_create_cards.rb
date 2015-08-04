class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.text :front_content
      t.text :back_content
      t.references :deck, index: true, foreign_key: true
      t.references :user, index: false, foreign_key: true
      t.integer :flips, default: 0
      
      t.timestamps null: false
    end
  end
end
