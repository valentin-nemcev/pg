class CreateImagesToArticles < ActiveRecord::Migration
  def self.up
    create_table "articles_images", :id => false do |t|
      t.column "image_id", :integer
      t.column "article_id", :integer
    end
  end

  def self.down
    drop_table "articles_images"
  end
end
