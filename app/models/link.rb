class Link < ActiveRecord::Base
  belongs_to :linked, :polymorphic => true
  validates_uniqueness_of :text
  validates_length_of :text, :in => 2..100
end

