class AddRevisions < ActiveRecord::Migration
  def self.up
    create_table "revisions", :force => true do |t|
      t.references  :category
      t.references  :article
      t.integer  :editor_id
      t.string   "title"
      t.string   "subtitle"
      t.string   "link"
      t.datetime "publication_date"
      t.boolean  "publicated", :default => false
      t.text     "text"
      t.text     "lead"
      t.timestamps 
    end
    
    create_table :articles, :force => true do |t|
      t.integer :current_revision_id
    end
  end

  def self.down
    drop_table :revisions
    drop_table :articles
  end
end
