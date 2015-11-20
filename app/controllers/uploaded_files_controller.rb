class UploadedFilesController < ApplicationController
  def create
    uploaded_file = CreateUploadedFile.call(params[:file], params[:type], current_user)
    if uploaded_file
      # return a json containing the path of the file
      respond_to do |format|
        format.json { render json: { file: uploaded_file.name.current_path } }
      end
    else
      # failed to save the file
    end
  end

  def destroy
  end
end
