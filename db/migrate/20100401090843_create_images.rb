class CreateImages < ActiveRecord::Migration
  def self.up
    create_table "images", :force => true do |t|
      t.timestamps
      t.string :title
      t.string :uri
      t.string :legacy_uri
    end
    add_index :images, :uri, :unique => true
    add_index :images, :legacy_uri, :unique => true
    add_column :images, :image_file_name, :string
    add_column :images, :image_content_type, :string
    add_column :images, :image_file_size, :integer
    
    create_table "articles_images", :id => false, :force => true do |t|
      t.integer "image_id",   :null => false
      t.integer "article_id",   :null => true
    end
    add_foreign_key(:articles_images, :images, :dependent => :delete)
    add_foreign_key(:articles_images, :articles, :dependent => :delete)
    add_index(:articles_images, [:image_id, :article_id], :unique => true)
  end

  def self.down
  end
end
