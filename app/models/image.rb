require 'ftools'
require 'RMagick'
class Image < ActiveRecord::Base
  ACCEPTED_FORMATS = ['JPG', 'PNG', 'PSD', 'GIF', 'BMP' ] 
  IMAGE_STORAGE_PATH = File.join(RAILS_ROOT, 'public/img')
  ThumbSize = 100
 
  ASPECT_RATIOS = {:face => 1, :photo => 3.0/2}
  
  has_and_belongs_to_many :revisions
  
  validates_presence_of :title 
  # validates_length_of :title, :in => 1..250
  validates_uniqueness_of :title
  
  attr_accessor :image_file, :image_path
  attr_protected :filename
  
  before_save :save_image_file
  validates_columns :layout_type
  before_destroy :delete_image_file
  
  def thumb_data
    return read_image.resize_to_fit(ThumbSize, ThumbSize)
  end
  
  def for_edit_data
    return read_image.resize_to_fit(600, 400)
  end
  
  def full_data
    return read_image
  end
  
  def image_data
    if self.layout_type == :banner
      img = read_image
      height = 150
      # img.resize_to_fit!(920, 10000)
      # img.crop(img.rows/2-height/2,0, 710, height)
      img.crop(0, img.rows/2-height/2, img.columns, height)
    else
      return read_image
    end
  end
  
  
  def true_width
    read_image.columns
  end
  
  def true_height
    read_image.rows
  end
  
  def print_size
    img = read_image
    "#{img.columns}x#{img.rows}"
  end
  
  protected  
    
    
    def read_image
      @image_data ||= Magick::Image.read(File.join(IMAGE_STORAGE_PATH, read_attribute(:filename))).first
    # rescue Magick::ImageMagickError, Magick::FatalImageMagickError
    #       return false;
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
      
      def generate_filename(name, counter, extension)
        if counter > 1
          "#{name}_#{counter}.#{extension}"
        else
          "#{name}.#{extension}"
        end
      end
      
      begin
        img = Magick::Image.read(image_path).first
      rescue Magick::ImageMagickError, Magick::FatalImageMagickError
        original_name = @image_file.nil? ? image_path : @image_file.original_filename
        errors.add(:image_file, "Неверный формат изображения (#{original_name})")
        return false;
      end
      if(img.columns <= 200 and img.rows <= 200)
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

      img.write File.join(IMAGE_STORAGE_PATH, fn)
      write_attribute(:filename, fn)
      
      write_attribute(:crop_bottom, img.rows)
      write_attribute(:crop_right, img.columns)
    end
  
    def delete_image_file
      filepath = File.join(IMAGE_STORAGE_PATH, read_attribute(:filename))
      if File.exists?(filepath) then File.delete(filepath) end
    end
end
