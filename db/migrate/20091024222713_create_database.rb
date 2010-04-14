#encoding: utf-8
class CreateDatabase < ActiveRecord::Migration
  def self.up
  
    create_table "articles", :force => true do |t|
      t.integer  "canonical_link_id"
      t.datetime "publication_date"
      t.boolean  "is_publicated",          :default => false, :null => false
      t.string   "uri", :null => false
      t.string   "title", :null => false
      t.string   "subtitle"
      t.text     "text"
      t.text     "lead"
      t.text     "text_html"
      t.text     "lead_html"
      t.string   "title_html"
      t.string   "subtitle_html"
      t.text     "legacy_text"
      t.text     "legacy_lead"
      t.string   "legacy_uri"
      t.integer  "legacy_id"
      
    end
    add_index :articles, :uri, :unique => true
    add_index :articles, :legacy_uri, :unique => true
    add_index :articles, :legacy_id, :unique => true
    
    
    create_table "layout_cells", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "place"
      t.integer  "top"
      t.integer  "left"
      t.integer  "height"
      t.integer  "width"
    end
    

    create_table "layout_items", :force => true do |t|
      t.integer "layout_cell_id"
      t.integer "article_id"
      t.integer "position",       :null => false
    end
    add_foreign_key(:layout_items, :layout_cells, :dependent => :delete)
    add_foreign_key(:layout_items, :articles, :dependent => :delete)
    
    create_table "quotes", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "text"
      t.string   "author"
    end

    create_table "users", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "name",                      :limit => 100, :default => ""
      t.string   "duties"
      t.string   "email"
      t.string   "crypted_password"
      t.string   "salt"
      t.string   "remember_token"
      t.datetime "remember_token_expires_at"
      t.enum     "role", :limit => [:admin, :editor, :bot], :default => :editor
    end
    add_index(:users, :email, :unique => true)
  
    User.create(:role=>:admin, 
    :email=>'zlob.o.zlob@gmail.com', 
    :name=>'Валентин Немцев', 
    :duties=>'Разработчик', 
    :password=>'politPass', :password_confirmation=>'politPass')
    
    User.create(:role=>:bot, 
    :email=>'bot@polit-gramota.ru', 
    :name=>'Скрипт импорта', 
    :duties=>'Робот', 
    :password=>'politPass', :password_confirmation=>'politPass')
  
  end

  def self.down
  end
end
