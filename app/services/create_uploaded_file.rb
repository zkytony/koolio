class CreateUploadedFile
  # Creates a UploadedFile record with the given parameters.
  # If source_type is "upload" (case-sensitive), this means
  # the target is a file directly uploaded by the user. If
  # source_type is "link", this means the target is a string
  # of url to the file.
  #
  # target - either a file, or a url to a file
  # file_type - the type of file
  # source_type - either "upload" or "link", indicating the type
  #               of source the target file is obtained from.
  # @return returns nil if the source_type is neither "upload"
  #         nor "link", or if the UploadedFile record failed to
  #         be saved with the given arguments.
  def self.call(target, file_type, source_type, user)
    uploaded_file = user.uploaded_files.new
    uploaded_file.type = file_type
    if source_type == "upload"
      uploaded_file.name = target
    elsif source_type == "link"
      uploaded_file.remote_name_url = target
    else
      return nil # invalid source_type
    end

    # save the uploaded_file
    if uploaded_file.save!
      uploaded_file
    else
      nil
    end
  end
end
