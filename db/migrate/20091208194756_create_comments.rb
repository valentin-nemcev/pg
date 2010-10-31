class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer  :article_id, :null => false
      t.datetime :publication_date
      t.string :author_name
      t.boolean :is_highlighted
      t.text :body
      t.text :body_html

      t.timestamps
    end
    
    add_column :articles, :comments_count, :integer, :default => 0
    
    add_foreign_key :comments, :articles, :column => "article_id" 
  end

  def self.down
    remove_column :articles, :comments_count
    drop_table :comments
  end
end
