class Tag < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_and_belongs_to_many :articles
  
  ordered_by "is_hidden, articles_count DESC"
  
  named_scope :for_main, {:conditions => 'not is_hidden and articles_count > 0'}
  
  before_save :generate_uri
  def generate_uri
    base_uri = uri = Russian.translit(self.name).parameterize
    counter = 2
    while self.class.exists?  ["uri = ? AND id <> #{self.id.to_i}", uri]
      uri = base_uri + "--#{counter}"
      counter += 1
    end
    write_attribute(:uri, uri)
  end
  
  
  def update_count
    update_attribute(:articles_count, self.articles.length)
  end
  
  def self.find_by_tag_string(str)
    self.all :conditions => {:name => str.split(', ').map(&:strip).reject(&:blank?) }
  end
end
