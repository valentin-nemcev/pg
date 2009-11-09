class Article < ActiveRecord::Base
  has_many :revisions, :dependent => :destroy
  belongs_to :current_revision, :foreign_key => 'current_revision_id', :class_name => 'Revision'
  validate :validate_revision
  after_save :update_revision, :destroy_orphaned_images
  REVISION_COLUMNS = Revision.column_names - %w{id article_id editor_id created_at updated_at}
  TEXT_COLUMN_OPTIONS = {:no => %w{text lead text_html lead_html}}
  TEXT_COLUMN_OPTIONS.default = []
  CALCULATIONS_OPTIONS << :text_fields
  
  belongs_to :category, :counter_cache => true
  validates_presence_of :category
  
  has_many :links, :dependent => :delete_all 
  belongs_to :canonical_link, :class_name => 'Link', :foreign_key => 'canonical_link_id' 
  after_save :make_link
  
  has_many :layout_cells, :through => :layout_items
  
  @@per_page = 10
  
  attr_accessor :editor#, *REVISION_COLUMNS
  
  def link
    return self.canonical_link.text until self.canonical_link.nil?
  end
  
  def images
    if not @revision.nil?
      @revision.parsed_images
    elsif not self.current_revision.nil?
      self.current_revision.images
    end
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
  
  def initialize(attributes = nil)
    
    attributes.stringify_keys! unless attributes.nil?
    revision_attributes = REVISION_COLUMNS.inject({}) do |revision_attributes, column|
      revision_attributes[column] = if attributes.nil? || attributes[column].nil?
        '' 
      else
         attributes.delete(column)
      end
      revision_attributes
    end
    
    super
    
    @attributes = revision_attributes.merge(@attributes)
  end
  
  protected
  
    def make_link
      link = Link.new(:text => Link.make_link_text(self.title), :article => self, :editor => self.editor)
      if link.save
        self.canonical_link = link
        self.save(false)
      end
      return true
    end
  
    def update_revision
      return true if  @revision.nil?
      
      @revision.article_id = self.id
      @revision.save(false)
      self.current_revision = @revision
      @revision = nil
      self.save(false)
    end
  
    def validate_revision
      self.revisions_count = 1 if self.new_record? # HACK
      return true if article_not_changed?
      @revision = Revision.new(
        REVISION_COLUMNS.inject(Hash.new) do |h, attr_name|
          h[attr_name]=self.send(attr_name) if self.respond_to? attr_name
          h
        end
      )
      @revision.editor_id = self.editor.id
      @revision.parse_text_fields
      if @revision.invalid?
        @revision.errors.each { |attr_name, msg| self.errors.add attr_name, msg }
        return false
      else
        return true
      end
    end
  
    def article_not_changed?
      return false if self.current_revision.nil?
      attrs_not_changed = (REVISION_COLUMNS - %w{text_html lead_html}).all? do |attr_name|
        logger.info { attr_name } 
        res = (self.send(attr_name) == self.current_revision.send(attr_name))
        logger.info { res.inspect }
        res 
      end
      images_not_changed = self.current_revision.images.all? {|img| img.updated_at > self.current_revision.updated_at } 
      attrs_not_changed and images_not_changed
    end
    
    def destroy_orphaned_images
      Image.destroy_images_without_revisions
    end
    
end