class CreateUploadedFile
  def self.call(file, type, user)
    uploaded_file = user.uploaded_files.new
    uploaded_file.name = file
    uploaded_file.type = type
    if uploaded_file.save!
      uploaded_file
    else
      nil
    end
  end
end
