require 'ftools'
require 'RMagick'
class Image < ActiveRecord::Base
  ACCEPTED_FORMATS = ['JPG', 'PNG', 'PSD', 'GIF', 'BMP' ] 
  IMAGE_STORAGE_PATH = File.join(RAILS_ROOT, 'public/img')
  ThumbSize = 100
  ImageTypes = ['face', 'banner', 'photo', 'image']
 
=begin
  TODO Добавить enum
=end
 
  has_and_belongs_to_many :revisions
  
  validates_presence_of :title 
  # validates_length_of :title, :in => 1..250
  validates_uniqueness_of :title
  
  attr_accessor :image_file, :image_path
  attr_protected :filename, :link
  
  before_save :save_image_file, :make_link, :validate_type
  before_destroy :delete_image_file
  
  def thumb_data
    return read_image.resize_to_fit(ThumbSize, ThumbSize)
  end
  
  def image_data
    if self.img_type == 'banner'
      img = read_image
      height = 150
      img.resize_to_fit!(920, 10000)
      img.crop(img.rows/2-height/2,0, 710, height)
    else
      return read_image
    end
  end
  
  def print_size
    img = read_image
    "#{img.columns}x#{img.rows}"
  end
  
  protected  
    
    def validate_type
      self.img_type = ImageTypes[0] until ImageTypes.include? self.img_type
    end
    
    def read_image
      Magick::Image.read(File.join(IMAGE_STORAGE_PATH, read_attribute(:filename))).first
    rescue Magick::ImageMagickError, Magick::FatalImageMagickError
      return false;
    end
    
    def make_link
      self.link = Link.make_link_text(self.title)      
    end
  
    def save_image_file
      if not @image_path.nil?
        image_path = @image_path
      else
        if @image_file.nil? or not @image_file.kind_of?(Tempfile)
          if self.new_record?
            errors.add(:image_file, "Отсутствует файл с изображением")
            return false
          else
            return true
          end
        end
        image_path = @image_file.path
      end
      
      
      begin
        img = Magick::Image.read(image_path).first
      rescue Magick::ImageMagickError, Magick::FatalImageMagickError
        original_name = @image_file.nil? ? image_path : @image_file.original_filename
        errors.add(:image_file, "Неверный формат изображения (#{original_name})")
        return false;
      end
      if(img.columns <= 200 and img.rows <= 200)
        self.img_type = 'face'
      else
        self.img_type = 'image'
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
