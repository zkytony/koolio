class CreateUploadedFiles < ActiveRecord::Migration
  def change
    create_table :uploaded_files do |t|
      t.string :name
      t.string :type
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :uploaded_files, [:user_id, :name], unique: true
  end
end
