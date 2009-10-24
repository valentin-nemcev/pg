class Category < ActiveRecord::Base
  has_many :articles
  
  has_many :links, :as => :linked, :dependent => :delete_all 
  belongs_to :canonical_link, :class_name => 'Link', :foreign_key => 'canonical_link_id'
  after_save :make_link
  
  before_save :set_position
  
  validates_length_of :title, :in => 2..100
  validates_uniqueness_of :title
  
=begin
  TODO Вынести в отдельный модуль или заменить плагином
=end
  def move(direction)
    other = case direction
    when :down
      Category.first(:conditions => ['position > ? AND archived = ?', self.position, self.archived], :order => 'position ASC')
    when :up
      Category.first(:conditions => ['position < ? AND archived = ?', self.position, self.archived], :order => 'position DESC')
    end
    return if other.nil?
    self.position, other.position = other.position, self.position
    self.save
    other.save
  end
  
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
    def set_position
      if self.position.blank? or self.position == 0 
        self.position = Category.maximum(:position, :conditions => {:archived => self.archived})
        self.position ||= 0
        self.position += 1
      end
    end
    
    def make_link
       link = Link.new(:text => Link.make_link_text(self.title), :linked => self)
       if link.save
         self.canonical_link = link
         self.save(false)
       end
       return true
     end
end
