class Tag < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_and_belongs_to_many :articles
  
  ordered_by "is_hidden, articles_count DESC"
  
  named_scope :for_main, {:conditions => 'not is_hidden and articles_count > 0'}
  
  named_scope :ordered_by_articles, 
    :select => '`tags`.*, count(`articles_tags`.article_id) as articles_count',
    :joins => 'LEFT JOIN `articles_tags` ON `articles_tags`.tag_id = `tags`.id', 
    :group => 'tags.id', 
    :order => 'articles_count desc' 
  
  has_uri :name
  
  named_scope :with_spaces, :conditions => "name LIKE ' %'"
  
  
  def update_count
    update_attribute(:articles_count, self.articles.length)
    self
  end
  
  def self.find_by_tag_list(list)
    self.all :conditions => {:name => tag_list_to_array(list)}
  end
  
  def self.find_or_create_by_tag_list(list)
    tag_list_to_array(list).map do |tag_name|
      self.find_or_create_by_name tag_name
    end
  end
  
  def self.tag_list_to_array(list)
    return [] if list.nil?
    list = list.split(',') unless list.kind_of? Array
    list.map(&:strip).reject(&:blank?)
  end
  
  
    
end
