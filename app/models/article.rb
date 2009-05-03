class Article < ActiveRecord::Base
  has_many :revisions, :dependent => :delete_all
  belongs_to :current_revision, :foreign_key => 'current_revision_id', :class_name => 'Revision'
  has_many :links, :as => :linked
  belongs_to :canonical_link, :class_name => 'Link', :foreign_key => 'canonical_link_id'
  accepts_nested_attributes_for :links
  
  def title
    self.current_revision.title # HACK
  end
end