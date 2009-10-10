class Revision < ActiveRecord::Base
  belongs_to :article
  belongs_to :editor, :class_name => 'User', :foreign_key => 'editor_id'
  has_and_belongs_to_many :images
  
  validates_presence_of :title #, :link
  validates_length_of :title, :in => 3..250
  # validates_length_of :link, :in => 2..100
  # validates_format_of :link, :with => /^[a-zA-Z0-9\-_]+$/
  
  # accepts_nested_attributes_for :article

  before_save :extract_images
  after_destroy :delete_article_without_revisions
  
  
  
  module RedCloth::Formatters::ImageExtractor
    include RedCloth::Formatters::Base
    include RedCloth::Formatters::HTML 
    @@extracted_images = []

    def self.extracted_images
     @@extracted_images
    end

    def image(opts)
     Rails.logger.info opts.inspect
     @@extracted_images << opts[:src] unless opts[:src].nil?
     return ''
    end
  
  end
  
  module ::RedCloth
    class TextileDoc
      def extract_images( *rules )
        apply_rules(rules)
        to(RedCloth::Formatters::ImageExtractor)
      end
    end
  end
  
  
  protected
    
    def extract_images
      RedCloth.new(self.text).extract_images
      # r.to(RedCloth::Formatters::ImageExtractor)
      logger.info { "!________" }
      logger.info { RedCloth::Formatters::ImageExtractor.extracted_images }
      true
    end
    
    def delete_article_without_revisions
      if self.article and self.article.revisions.size == 0
        self.article.destroy
      end
    end
end
