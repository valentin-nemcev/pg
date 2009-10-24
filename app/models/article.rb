class Article < ActiveRecord::Base
  has_many :revisions, :dependent => :destroy
  belongs_to :current_revision, :foreign_key => 'current_revision_id', :class_name => 'Revision'
  validate :validate_revision
  after_save :update_revision
  REVISION_COLUMNS = Revision.column_names - %w{id article_id created_at updated_at}
  TEXT_COLUMN_OPTIONS = {:no => %w{text lead text_html lead_html}}
  TEXT_COLUMN_OPTIONS.default = []
  CALCULATIONS_OPTIONS << :text_fields
  
  belongs_to :category, :counter_cache => true
  
  has_many :links, :as => :linked, :dependent => :delete_all 
  belongs_to :canonical_link, :class_name => 'Link', :foreign_key => 'canonical_link_id' 
  after_save :make_link
  
  # has_many :layout_items, :as => :content, :dependent => :destroy  
  has_many :layout_items, :through => :layout_items_to_content
  
  @@per_page = 10
  
  attr_accessor :editor 
  
  def link
    return self.canonical_link.text until self.canonical_link.nil?
  end
  
  def images
    return self.current_revision.images until self.current_revision.nil?
  end
  
  class << self
    def find_with_revisions(*args)
      opts = args.extract_options!
      if not opts[:select]
        revision_cols = REVISION_COLUMNS
        revision_cols -= TEXT_COLUMN_OPTIONS[opts.delete(:text_fields)]
        select = revision_cols.inject('articles.*') { |select, col| select << ", `revisions`.#{col}" }
        self.with_scope(:find => {:select => select, :joins => :current_revision}) do
          args << opts
          find_without_revisions(*args)
        end
      end
      
    end
    alias_method :find_without_revisions, :find
    alias_method :find, :find_with_revisions
    
  end
  
  protected
  
    def make_link
      link = Link.new(:text => Link.make_link_text(self.title), :linked => self, :editor => self.editor)
      if link.save
        self.canonical_link = link
        self.save(false)
      end
      return true
    end
  
    def update_revision
      return true if self.current_revision.nil?
      self.current_revision.article_id = self.id
      self.current_revision.editor_id = editor.id unless editor.nil?
      self.current_revision.save(false) 
    end
  
    def validate_revision
      return true if article_not_changed?
      rev = self.current_revision = Revision.new(
        REVISION_COLUMNS.inject(Hash.new) do |h, attr_name|
          h[attr_name]=self.send(attr_name) if self.respond_to? attr_name
          h 
        end
      )
      if rev.invalid?
        rev.errors.each { |attr_name, msg| self.errors.add attr_name, msg }
        return false
      else
        return true
      end
    end
  
    def article_not_changed?
      return false if self.current_revision.nil?
      (REVISION_COLUMNS - %w{text_html lead_html image_ids}).all? do |attr_name|
        logger.info { attr_name } 
        res = (self.send(attr_name) == self.current_revision.send(attr_name))
        logger.info { res.inspect }
        res 
      end
    end
    
end