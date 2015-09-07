class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.integer :recommendable_id
      t.string :recommendable_type

      t.timestamps null: false
    end
    add_index :recommendations, :from_user_id
    add_index :recommendations, :to_user_id
    add_index :recommendations, :recommendable_id
    add_index :recommendations, [:to_user_id, :recommendable_type, :recommendable_id, :from_user_id], unique: true, name: "by_toU_Rtype_Rid_fromU"
  end
end
