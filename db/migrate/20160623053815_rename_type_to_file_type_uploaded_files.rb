class RenameTypeToFileTypeUploadedFiles < ActiveRecord::Migration
  def up
    rename_column :uploaded_files, :type, :file_type
  end

  def down
  end
end
