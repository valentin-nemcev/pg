class CreateImagesToRevisions < ActiveRecord::Migration
  def self.up
    drop_table "articles_images"
    create_table "images_revisions", :id => false do |t|
      t.column "image_id", :integer
      t.column "revision_id", :integer
    end
  end

  def self.down
    create_table "articles_images", :id => false do |t|
      t.column "image_id", :integer
      t.column "article_id", :integer
    end
    drop_table "images_revisions"
  end
end
