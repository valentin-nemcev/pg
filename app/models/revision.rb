class Revision < ActiveRecord::Base
  belongs_to :article, :counter_cache => true
  belongs_to :editor, :class_name => 'User', :foreign_key => 'editor_id'
  has_and_belongs_to_many :images
  
  validates_presence_of :title #, :link
  validates_length_of :title, :in => 3..250
  # validates_length_of :link, :in => 2..100
  # validates_format_of :link, :with => /^[a-zA-Z0-9\-_]+$/
  
  # accepts_nested_attributes_for :article

  before_save :parse_text_fields
  after_save :save_images
  after_destroy :delete_article_without_revisions
  
  
  
  module RedCloth::Formatters::HTMLWithImageParser
    include RedCloth::Formatters::HTML 
    alias_method :html_image, :image
    
    @@extracted_images = []
    
    def self.text_type= (text_type)
     @@text_type = text_type
    end
    
    def self.extracted_images
     @@extracted_images
    end
    
    def self.reset_extracted_images
     @@extracted_images = []
    end

    def image(opts)
      return '' unless image = Image.find_by_link(opts[:src])
      @@extracted_images << image
      opts[:src] = "/images/#{opts[:src]}"
      if @@text_type == :lead and (image.img_type == 'image' or image.img_type == 'banner')
        image.img_type = 'banner'
        image.save(false)
        "<div class='banner' style='background-image: url(#{escape_attribute opts[:src]})'>&nbsp</div>"
      else
        opts[:class] = image.img_type
        "<img src=\"#{escape_attribute opts[:src]}\"#{pba(opts)} alt=\"#{escape_attribute opts[:alt].to_s}\" />"
      end
    end
    
    # def image(opts)
    #       opts.delete(:align)
    #       opts[:alt] = opts[:title]
    #       img = "<img src=\"#{escape_attribute opts[:src]}\"#{pba(opts)} alt=\"#{escape_attribute opts[:alt].to_s}\" />"  
    #       img = "<a href=\"#{escape_attribute opts[:href]}\">#{img}</a>" if opts[:href]
    #       img
    #     end
  end
  
  module ::RedCloth
    class TextileDoc
      def parse_text(text_type, *rules )
        RedCloth::Formatters::HTMLWithImageParser.text_type = text_type
        apply_rules(rules)
        RedCloth::Formatters::HTMLWithImageParser.reset_extracted_images
        html = to(RedCloth::Formatters::HTMLWithImageParser)
        images = RedCloth::Formatters::HTMLWithImageParser.extracted_images
        return html, images
      end
    end
  end
  
  def reparse_text_fields
    self.parse_text_fields
    # self.save_images
    self.save
  end
  
  protected
    
    def parse_text_fields
      self.lead_html, @lead_images = RedCloth.new(self.lead).parse_text(:lead)
      self.text_html, @text_images = RedCloth.new(self.text).parse_text(:text)
      true
    end
    
    def save_images
      self.images.clear
      (@text_images + @lead_images).each {|img| self.images << img }
    end
    
    def delete_article_without_revisions
      if self.article and self.article.revisions.size == 0
        self.article.destroy
      end
    end
end
