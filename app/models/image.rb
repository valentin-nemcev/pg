require 'ftools'
require 'RMagick'
class Image < ActiveRecord::Base
  ACCEPTED_FORMATS = ['JPG', 'PNG', 'PSD', 'GIF', 'BMP' ] 
  IMAGE_STORAGE_PATH = File.join(RAILS_ROOT, 'storage/images')
  IMAGE_PUBLIC_PATH = File.join(RAILS_ROOT, 'public/img')
  
  THUMB_SIZE = 100
 
  ASPECT_RATIOS = {:face => 1, :photo => 3.0/2}
  
  has_and_belongs_to_many :revisions
  
  validates_presence_of :title 
  # validates_length_of :title, :in => 1..250
  validates_uniqueness_of :title
  
  attr_accessor :image_file, :image_path
  attr_protected :filename
  
  before_save :save_original, :save_derivatives
  validates_columns :layout_type
  before_destroy :delete_image_file
  
  
  def self.resave_all
    self.find_each(:batch_size => 100) do |img|
      img.save_derivatives
    end
  end
  
  def thumb_link
    '/img/thumbs/'+filename
  end

  def preview_link
    '/img/previews/'+filename
  end
  
  def link
    '/img/'+filename
  end
  
  def true_width
    read_image.columns
  end
  
  def true_height
    read_image.rows
  end
  
  def crop_width
    crop_right - crop_left
  end  
  
  def crop_height
    crop_bottom - crop_top
  end
  
  def print_size
    img = read_image
    "#{img.columns}x#{img.rows}"
  end
  
  def save_derivatives
    img = read_image
    crop_rect = [crop_left, crop_top, crop_width, crop_height]
    img.crop(*crop_rect).write(File.join(IMAGE_PUBLIC_PATH, self.filename))
    
    img.crop(*crop_rect).resize_to_fit(THUMB_SIZE,THUMB_SIZE).write(File.join(IMAGE_PUBLIC_PATH, 'thumbs', self.filename))
    img.resize_to_fit(600, 400).write(File.join(IMAGE_PUBLIC_PATH, 'previews', self.filename))
  end
  
  protected  
    
    def read_image
      @image_data ||= Magick::Image.read(File.join(IMAGE_STORAGE_PATH, read_attribute(:filename))).first
    rescue Magick::ImageMagickError, Magick::FatalImageMagickError
      return false;
    end
    
    def generate_filename(name, counter, extension)
      if counter > 1
        "#{name}_#{counter}.#{extension}"
      else
        "#{name}.#{extension}"
      end
    end
    
    
    def save_original
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
        @image_data = Magick::Image.read(image_path).first
      rescue Magick::ImageMagickError, Magick::FatalImageMagickError
        original_name = @image_file.nil? ? image_path : @image_file.original_filename
        errors.add(:image_file, "Неверный формат изображения (#{original_name})")
        return false;
      end
      if(@image_data.columns <= 200 and @image_data.rows <= 200)
        self.layout_type = :face
      else
        self.layout_type = :image
      end

      base = Link.make_link_text(self.title)
      count = 1
      ext = 'jpg'
      fn = generate_filename(base, count, ext)
      while self.class.find_by_filename(fn)
        count += 1
        fn = generate_filename(base, count, ext)
      end

      @image_data.write File.join(IMAGE_STORAGE_PATH, fn)
      write_attribute(:filename, fn)
      
      write_attribute(:crop_bottom, @image_data.rows)
      write_attribute(:crop_right, @image_data.columns)
    end
  
    def delete_image_file
      filepath = File.join(IMAGE_STORAGE_PATH, read_attribute(:filename))
      if File.exists?(filepath) then File.delete(filepath) end
    end
end
