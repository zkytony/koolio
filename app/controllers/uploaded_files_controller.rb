require 'uri'

class UploadedFilesController < ApplicationController
  def create
    coords = {}
    if static_image?(params[:file_type])
      coords[:x] = params[:crop_x]
      coords[:y] = params[:crop_y]
      coords[:w] = params[:crop_w]
      coords[:h] = params[:crop_h]
    end
    uploaded_file = CreateUploadedFile.call(params[:target], params[:file_type], params[:source_type], coords, current_user)
    if uploaded_file
      file_uri = URI.parse(uploaded_file.name.url)
      if !file_uri.host.nil? || !file_uri.scheme.nil?
        root_url = "#{file_uri.scheme}://#{file_uri.host}"
      else
        root_url = ""
      end

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

  private
  
    # Check if given type is static image
    def static_image?(file_type)
      file_type.include?('image/bmp') || file_type.include?('image/jpeg') || file_type.include?('image/png')
    end

end
