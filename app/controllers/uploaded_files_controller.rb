class UploadedFilesController < ApplicationController
  def create
    uploaded_file = CreateUploadedFile.call(params[:file], params[:type], current_user)
    if uploaded_file
      # return a json containing the path of the file
      respond_to do |format|
        format.js { render json: { file_name: uploaded_file.name_identifier, store_dir: uploaded_file.name.store_dir } }
      end
    else
      # failed to save the file
    end
  end

  def destroy
  end
end
