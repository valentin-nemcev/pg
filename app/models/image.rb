#encoding: utf-8

class Image < ActiveRecord::Base
  
  has_attached_file :image, :styles => { :thumb => ["100x100>", :jpg] },
                          :convert_options => { :all => "-strip" },
                          :path => ':rails_root/public/img/:style_:id.:extension',
                          :url => '/img/:style_:id.:extension'
  
  validates_attachment_presence :image
  validates_attachment_content_type :image, :content_type => /^image\/.+/
  
  has_and_belongs_to_many :articles


  delegate :url, :to => :image
  
  ordered_by 'created_at DESC'
  named_scope :ordered_by_articles, :joins => :articles, :group => 'images.id', :order => 'count(articles.id) desc' 
  
  def self.destroy_images_without_revisions
    images = Image.all(:joins => 'LEFT JOIN images_revisions ON images_revisions.image_id = images.id', 
                        :conditions => 'images_revisions.image_id is null')
    images.each(&:destroy)
  end
end
