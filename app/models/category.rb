class Category < ActiveRecord::Base
  has_many :articles
  
  has_many :links, :dependent => :delete_all 
  belongs_to :canonical_link, :class_name => 'Link', :foreign_key => 'canonical_link_id'
  after_save :make_link
  
  before_save :set_position
  
  validates_length_of :title, :in => 2..100
  validates_uniqueness_of :title
  
  named_scope :top_menu, :conditions => {:archived => false, :hidden => false}, :order => 'position ASC'
  named_scope :archived, :conditions => {:archived => true, :hidden => false}, :order => 'position ASC'
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
    other_position = other.position
    self_position = self.position
    other.update_attribute(:position, nil)
    self.update_attribute(:position, other_position)
    other.update_attribute(:position, self_position)
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
      # position_not_unique = self.class.all(:conditions => {:archived => self.archived, :position => self.position})
      if self.position.blank? or self.position == 0 or self.archived_changed?
        self.position = Category.maximum(:position, :conditions => {:archived => self.archived})
        self.position ||= 0
        self.position += 1
      end
    end
    
    def make_link
       link = Link.new(:text => Link.make_link_text(self.title), :category => self)
       if link.save
         self.canonical_link = link
         self.save(false)
       end
       return true
     end
end
