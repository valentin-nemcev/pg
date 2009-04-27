class Link < ActiveRecord::Base
  belongs_to :linkable, :polymorphic => true
  validates_uniqueness_of :text
end

