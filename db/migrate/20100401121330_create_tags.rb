class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name, :null => false
      t.string :uri, :null => false
      t.timestamps
    end
    add_index(:tags, :name, :unique => true)
    add_index(:tags, :uri, :unique => true)
    
    create_table "articles_tags", :id => false, :force => true do |t|
      t.integer "tag_id",   :null => false
      t.integer "article_id",   :null => true
    end
    add_foreign_key(:articles_tags, :tags, :dependent => :delete)
    add_foreign_key(:articles_tags, :articles, :dependent => :delete)
    add_index(:articles_tags, [:tag_id, :article_id], :unique => true)
  end

  def self.down
    drop_table :tags
  end
end
