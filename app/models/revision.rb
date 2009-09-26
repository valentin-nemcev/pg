class Revision < ActiveRecord::Base
  belongs_to :article
  belongs_to :editor, :class_name => 'User', :foreign_key => 'editor_id'
  
  validates_presence_of :title #, :link
  validates_length_of :title, :in => 3..250
  # validates_length_of :link, :in => 2..100
  # validates_format_of :link, :with => /^[a-zA-Z0-9\-_]+$/
  
  accepts_nested_attributes_for :article

  after_destroy :delete_article_without_revisions
  
  protected
    
    
    def delete_article_without_revisions
      if self.article and self.article.revisions.size == 0
        self.article.destroy
      end
    end
end
