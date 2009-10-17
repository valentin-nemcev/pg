class Link < ActiveRecord::Base
  belongs_to :linked, :polymorphic => true, :counter_cache => true
  belongs_to :editor, :class_name => 'User', :foreign_key => 'editor_id'
  
  validates_uniqueness_of :text
  validates_length_of :text, :in => 2..100
  
  after_destroy :change_parent_canonical_link
  
  def self.make_link_text text
    Russian.translit(text).parameterize
  end
  
  
  def canonical?
    self.linked.canonical_link == self
  end
  
  protected
    def change_parent_canonical_link
      return true unless self.linked.canonical_link.nil? || self.linked.links.empty?
      self.linked.canonical_link = self.linked.links.first
      self.linked.save(false)
    end  
end

