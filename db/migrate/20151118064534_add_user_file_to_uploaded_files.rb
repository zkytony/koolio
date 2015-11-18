class AddUserFileToUploadedFiles < ActiveRecord::Migration
  def change
    add_column :uploaded_files, :name, :string
  end
end
