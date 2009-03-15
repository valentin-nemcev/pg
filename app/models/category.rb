class Category < ActiveRecord::Base
  has_many :articles
  
  validates_presence_of :title, :link
  validates_length_of :title, :in => 3..250
  validates_length_of :link, :in => 2..100
  validates_format_of :link, :with => /^[a-zA-Z0-9-_]+$/
  validates_uniqueness_of :link
end
