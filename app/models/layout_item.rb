class LayoutItem < ActiveRecord::Base
  
  belongs_to :layout_cell
  belongs_to :article
  
  after_save :delete_if_empty
  before_save :set_position
  
  def move(direction)
    other = case direction
    when :down
      LayoutItem.first(:conditions => ['position > ? AND layout_cell_id = ?', self.position, self.layout_cell_id], :order => 'position ASC')
    when :up
      LayoutItem.first(:conditions => ['position < ? AND layout_cell_id = ?', self.position, self.layout_cell_id], :order => 'position DESC')
    end
    return if other.nil?
    self.position, other.position = other.position, self.position
    self.save
    other.save
  end
  
  protected
    def set_position
      if not self.position
        self.position = LayoutItem.maximum(:position, :conditions => {:layout_cell_id => self.layout_cell_id})
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