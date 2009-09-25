class Article < ActiveRecord::Base
  has_many :revisions, :dependent => :delete_all
  belongs_to :current_revision, :foreign_key => 'current_revision_id', :class_name => 'Revision'
  has_many :links, :as => :linked
  belongs_to :canonical_link, :class_name => 'Link', :foreign_key => 'canonical_link_id' 
  has_and_belongs_to_many :images
  # accepts_nested_attributes_for :links
  
  validate :validate_revision
  after_save :make_link, :update_revision 
  RevisionColumns = Revision.column_names - %w{id article_id created_at updated_at}
  
  attr_accessor :editor, *RevisionColumns
  
  protected
  
  def after_find
    RevisionColumns.each do |attr_name| 
      self.send "#{attr_name}=", self.current_revision[attr_name]
    end
  end
  
  def make_link
    # return true if self.link.nil? or self.link.empty?
    link = Link.new(:text => Link.make_link_text(self.title), :linked => self, :editor => self.editor)
    if link.save
      self.canonical_link = link
      self.save
    end
    return true
  end
  
  def update_revision
    self.current_revision.article_id = self.id
    self.current_revision.editor_id = editor.id
    self.current_revision.save(false) 
  end
  
  def validate_revision
    return true if article_not_changed?
    rev = self.current_revision = Revision.new(RevisionColumns.inject(Hash.new){|h, attr_name| h[attr_name]=self.send(attr_name); h })
    if rev.invalid?
      rev.errors.each { |attr_name, msg| self.errors.add attr_name, msg }
      return false
    else
      return true
    end
  end
  
  def article_not_changed?
    return false if self.current_revision.nil?
    RevisionColumns.all? do |attr_name|
      self.send(attr_name) == self.current_revision.send(attr_name)
    end
  end
  
  # def title
  #   self.current_revision.title # HACK
  # end
  
  # def initialize(attributes = nil)
  #     unless attributes.nil?
  #       rev = self.build_current_revision
  #       attributes.each do |attr_name, attr_val|
  #         rev[attr_name] = attributes.delete(attr_name) if rev.attribute_names.include? attr_name
  #       end
  #     end
  #     super    
  #   end
  #   
  #   def method_missing(method, *arg)
  #     name = method.to_s
  #     attr_name = (name[-1].chr == '=') ? name[0..-2] : name
  #     self.current_revision ||= Revision.new  
  #     if self.current_revision.attribute_names.include? attr_name
  #       return self.current_revision.send(method, *arg)   
  #     else
  #       super
  #     end
  #   end
  #   
  #   def editor=(e) 
  #     return self.current_revision.editor=e 
  #   end
  #   
  #   def editor() 
  #     return self.current_revision.editor
  #   end
  
end