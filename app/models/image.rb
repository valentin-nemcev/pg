require 'ftools'
require 'RMagick'
class Image < ActiveRecord::Base
  ACCEPTED_FORMATS = ['JPG', 'PNG', 'PSD', 'GIF', 'BMP' ] 
  IMAGE_STORAGE_PATH = File.join(RAILS_ROOT, 'storage')
  
  attr_accessor :image_file
  attr_protected :filename
  
  before_save :save_image_file
  before_destroy :delete_image_file
  
  def thumb_data
    begin
      img = Magick::Image.read(File.join(IMAGE_STORAGE_PATH, read_attribute(:filename))).first
    rescue Magick::ImageMagickError, Magick::FatalImageMagickError
      return false;
    end
    
    return img.resize_to_fit!(64,64)
  end
  
  def image_data
    begin
      img = Magick::Image.read(File.join(IMAGE_STORAGE_PATH, read_attribute(:filename))).first
    rescue Magick::ImageMagickError, Magick::FatalImageMagickError
      return false;
    end
    return img
  end
  
  protected  
  
    def save_image_file
      return true if @image_file.nil?
      begin
        img = Magick::Image.read(@image_file.path).first
      rescue Magick::ImageMagickError, Magick::FatalImageMagickError
        errors.add(:image_file, "^Неверный формат изображения (#{@image_file.original_filename})")
        return false;
      end
      filename = "#{Time.now.to_i}#{rand(1000)}.jpg"
      img.write File.join(IMAGE_STORAGE_PATH, filename)
      write_attribute(:filename, filename)
      # logger.debug 'test!' if ACCEPTED_FORMATS.include? img.format 
      # logger.debug  img.format
      # File.mv @image_file.path, File.join(RAILS_ROOT, 'storage', @image_file.original_filename) 
    end
  
    def delete_image_file
      filepath = File.join(IMAGE_STORAGE_PATH, read_attribute(:filename))
      if File.exists?(filepath) then File.delete(filepath) end
    end
end
