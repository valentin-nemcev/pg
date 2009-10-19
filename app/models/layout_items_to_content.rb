class LayoutItemsToContent < ActiveRecord::Base
  def self.table_name() "layout_items_to_content" end
  
  belongs_to :layout_item
  belongs_to :article
  
  after_save :delete_if_empty
  before_save :set_position
  
  def move(direction)
    other = case direction
    when :down
      LayoutItemsToContent.first(:conditions => ['position > ? AND layout_item_id = ?', self.position, self.layout_item_id], :order => 'position ASC')
    when :up
      LayoutItemsToContent.first(:conditions => ['position < ? AND layout_item_id = ?', self.position, self.layout_item_id], :order => 'position DESC')
    end
    return if other.nil?
    self.position, other.position = other.position, self.position
    self.save
    other.save
  end
  
  protected
    def set_position
      if not self.position
        self.position = LayoutItemsToContent.maximum(:position, :conditions => {:layout_item_id => self.layout_item_id})
        self.position ||= 0
        self.position += 1
      end
    end 
    def delete_if_empty
      if self.article_id.blank? 
        self.destroy
      end
      return true
    end
end 