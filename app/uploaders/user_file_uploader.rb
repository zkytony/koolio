# encoding: utf-8

class UserFileUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Videos
  # include CarrierWave::Video

  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog


  IMAGE_EXTENSIONS = %w(jpg jpeq gif png)
  VIDEO_EXTENSIONS = %w(mp4)
  

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # create a new "process_extensions" method.  It is like "process", except
  # it takes an array of extensions as the first parameter, and registers
  # a trampoline method which checks the extension before invocation
  # FROM Gist: https://gist.github.com/995663
  def self.process_extensions(*args)
    extensions = args.shift
    args.each do |arg|
      if arg.is_a?(Hash)
        arg.each do |method, args|
          processors.push([:process_trampoline, [extensions, method, args]])
        end
      else
        processors.push([:process_trampoline, [extensions, arg, []]])
      end
    end
  end

  # our trampoline method which only performs processing if the extension matches
  # FROM Gist: https://gist.github.com/995663
  def process_trampoline(extensions, method, args)
    extension = File.extname(original_filename).downcase
    extension = extension[1..-1] if extension[0,1] == '.'
    self.send(method, *args) if extensions.include?(extension)
  end

  # lower the quality to make the file smaller
  process_extensions IMAGE_EXTENSIONS, :quality => 85
  # process_extensions VIDEO_EXTENSIONS, :encode_video => [:mp4, resolution: "300x300"]

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #

  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # 250 is the default minimum width/height of a card
  # 300 is the maximum height of a card
  #
  # It seems like when storage set to "fog", the image uploading
  # is too slow and the resize_to_fill cannot really apply the
  # gravity setting. It is crucial then to provide the functionality
  # to crop the image.
  version :thumb, :if => :image? do
     resize_to_fill(300, 300, 'Center')
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    IMAGE_EXTENSIONS + VIDEO_EXTENSIONS
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
  # Generate random and unique filename
  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

  def image?(new_file)
    new_file.content_type.include? 'image'
  end

  def video?(new_file)
    new_file.content_type.include? 'video'
  end
end
