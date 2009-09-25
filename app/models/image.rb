require 'ftools'
require 'RMagick'
class Image < ActiveRecord::Base
  ACCEPTED_FORMATS = ['JPG', 'PNG', 'PSD', 'GIF', 'BMP' ] 
  IMAGE_STORAGE_PATH = File.join(RAILS_ROOT, 'public/img')
  
  has_and_belongs_to_many :articles
  
  validates_presence_of :title 
  validates_length_of :title, :in => 3..250
  
  attr_accessor :image_file
  attr_protected :filename, :link
  
  before_save :save_image_file, :make_link
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
    
    def make_link
      self.link = Link.make_link_text(self.title)      
    end
  
    def save_image_file
      if @image_file.nil? or not @image_file.kind_of?(Tempfile)
        if self.new_record?
          errors.add(:image_file, "Отсутствует файл с изображением")
          return false
        else
          return true
        end
      end
      begin
        img = Magick::Image.read(@image_file.path).first
      rescue Magick::ImageMagickError, Magick::FatalImageMagickError
        errors.add(:image_file, "Неверный формат изображения (#{@image_file.original_filename})")
        return false;
      end
      # filename = "#{Time.now.to_i}#{rand(1000)}.jpg"
      filename =  Link.make_link_text(self.title)+'.jpg'
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
