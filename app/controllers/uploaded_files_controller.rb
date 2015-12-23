require 'uri'

class UploadedFilesController < ApplicationController
  def create
    uploaded_file = CreateUploadedFile.call(params[:file], params[:type], current_user)
    if uploaded_file
      file_uri = URI.parse(uploaded_file.name.url)
      root_url = "#{file_uri.scheme}://#{file_uri.host}"

      # return a json containing the path of the file
      respond_to do |format|
        # .name will access the carrierwave file object
        format.js { render json: { file_name: uploaded_file.name_identifier, store_dir: uploaded_file.name.store_dir, host: root_url } }
      end
    else
      # failed to save the file
    end
  end

  def destroy
  end
end
