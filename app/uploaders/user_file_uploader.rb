# encoding: utf-8

class UserFileUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  storage ENV['STORAGE_TYPE'].to_sym

  IMAGE_EXTENSIONS = %w(jpg jpeg gif png)
  STATIC_IMAGE_EXTENSIONS = %w(jpg jpeg png)
  VIDEO_EXTENSIONS = %w(mp4 webm gifv)
  
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

  # Create different versions of your uploaded files:
  # 250 is the default minimum width/height of a card
  # 300 is the maximum height of a card
  version :thumb, :if => :thumb_enabled? do
      resize_to_fill(300, 300, 'Center')
  end

  version :cropped, :if => :image? do
    process_extensions IMAGE_EXTENSIONS, :crop
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    IMAGE_EXTENSIONS + VIDEO_EXTENSIONS
  end

  # Override the filename of the uploaded files:
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

  # Check if given type is static image
  def static_image?(file_type)
    file_type.include?('image/bmp') || file_type.include?('image/jpeg') || file_type.include?('image/png')
  end

  def thumb_enabled?(new_file)
    ENV['STORAGE_TYPE'] == "file" && image?(new_file)
  end

  def video?(new_file)
    new_file.content_type.include? 'video'
  end

  # Crop the image
  def crop
    print model.type
    if static_image? model.type
      print "HI"
      if model.coords.present?
        manipulate! do |img|
          x = model.coords[:x]
          y = model.coords[:y]
          w = model.coords[:w]
          h = model.coords[:h]
          size = w << 'x' << h
          offset = x << '+' << y
          img.crop("#{size}+#{offset}")
          img
        end
      end
    else
      print "BYE"
      resize_to_fill(300, 300, 'Center')
    end
  end
end
