class Navigation < ActiveRecord::Base

  has_many :navigation_tags
  has_many :tags, :through => :navigation_tags, :order => 'navigation_tags.position'

  def tag_string
    self.tags.collect(&:name).join(', ')
  end

  def tag_string=(tags)
    self.navigation_tags.destroy_all
    self.tags = Tag.find_or_create_by_tag_list(tags)
  end
end
