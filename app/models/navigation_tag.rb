class NavigationTag < ActiveRecord::Base

  default_scope :order => 'position'
  acts_as_list :scope => :navigation

  belongs_to :tag
  belongs_to :navigation
end
