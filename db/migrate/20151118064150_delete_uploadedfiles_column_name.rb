class DeleteUploadedfilesColumnName < ActiveRecord::Migration
  def up
    remove_column :uploaded_files, :name
  end

  def down
    add_column :uploaded_files, :name, :string
  end
end
