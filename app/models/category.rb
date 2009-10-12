class Category < ActiveRecord::Base
  has_many :articles
  
  has_many :links, :as => :linked, :dependent => :destroy 
  belongs_to :canonical_link, :class_name => 'Link', :foreign_key => 'canonical_link_id'
  after_save :make_link
  
  validates_length_of :title, :in => 2..100
  validates_uniqueness_of :title
  
  
  
  def link
    return self.canonical_link.text until self.canonical_link.nil?
  end
  
  def most_recent_article
    Article.first(:conditions=>{:category_id=>self}, :order => 'publication_date DESC')
  end
  
  
  def destroy_with_articles
    self.articles.each(&:destroy)
    self.destroy
  end
  
  protected
    
    def make_link
       link = Link.new(:text => Link.make_link_text(self.title), :linked => self)
       if link.save
         self.canonical_link = link
         self.save(false)
       end
       return true
     end
end
