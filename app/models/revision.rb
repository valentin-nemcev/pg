class Revision < ActiveRecord::Base
  belongs_to :category
  belongs_to :article
  belongs_to :editor, :class_name => 'User', :foreign_key => 'editor_id'
  
  validates_presence_of :title #, :link
  validates_length_of :title, :in => 3..250
  # validates_length_of :link, :in => 2..100
  # validates_format_of :link, :with => /^[a-zA-Z0-9\-_]+$/
  
  accepts_nested_attributes_for :article

  after_destroy :delete_article_without_revisions
  before_save :make_link
  attr_accessor :link
  
  protected
    def make_link
      return true if self.link.empty?
      link = Link.new(:text => self.link, :linked => self.article)
      link.save
      self.article.canonical_link = link
      return true
    end
    
    def delete_article_without_revisions
      if self.article.revisions.size == 0
        self.article.destroy
      end
    end
end
