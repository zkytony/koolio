class CreateDeckUserAssociations < ActiveRecord::Migration
  def change
    create_table :deck_user_associations do |t|
      t.references :deck, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :type, default: -1

      t.timestamps null: false
    end
  end
end
