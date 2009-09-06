class Link < ActiveRecord::Base
  belongs_to :linked, :polymorphic => true
  belongs_to :editor, :class_name => 'User', :foreign_key => 'editor_id'
  
  validates_uniqueness_of :text
  validates_length_of :text, :in => 2..100
  
  
  def self.make_link_text text
    Russian.translit(text).parameterize
  end
end

