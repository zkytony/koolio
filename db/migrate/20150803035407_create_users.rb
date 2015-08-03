class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.date :birthday
      t.string :gender
      t.boolean :activated

      t.timestamps null: false
    end
  end
end
