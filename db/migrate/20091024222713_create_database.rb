class CreateDatabase < ActiveRecord::Migration
  def self.up
  
    create_table "articles", :force => true do |t|
      t.integer  "current_revision_id"
      t.integer  "canonical_link_id"
      t.integer  "category_id",         :null => false
      t.datetime "publication_date"
      t.boolean  "publicated",          :default => false
      t.integer  "revisions_count",     :default => 0
      t.integer  "links_count",         :default => 0
    end
   
    create_table "revisions", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "article_id",         :null => false
      t.integer  "editor_id",         :null => false
      t.string   "title"
      t.string   "subtitle"
      t.text     "text"
      t.text     "lead"
      t.text     "text_html"
      t.text     "lead_html"
    end
    add_foreign_key(:revisions, :articles)
    add_foreign_key(:articles, :revisions, :column => "current_revision_id", :dependent => :nullify)
    
    create_table "categories", :force => true do |t|
      t.integer  "canonical_link_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "title",         :null => false
      t.boolean  "archived",          :default => false
      t.integer  "position",          :default => 0,     :null => false
      t.integer  "articles_count",    :default => 0
      t.integer  "links_count",       :default => 0
    end
    add_foreign_key(:articles, :categories)
    
    create_table "links", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "text", :null => false, :unique => true
      t.integer  "category_id", :null => true
      t.integer  "article_id" , :null => true
    end
    add_foreign_key(:articles, :links, :column => "canonical_link_id", :dependent => :nullify)
    add_foreign_key(:categories, :links, :column => "canonical_link_id", :dependent => :nullify)
    add_foreign_key(:links, :articles)
    add_foreign_key(:links, :categories)
    add_index(:links, :text, :unique => true)
    
    create_table "images", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "title"
      t.string   "link"
      t.string   "filename",   :null => false
      t.string   "img_type"
    end
    add_index(:images, :filename, :unique => true)
    
    create_table "images_revisions", :id => false, :force => true do |t|
      t.integer "image_id",   :null => false
      t.integer "revision_id",   :null => true
    end
    add_foreign_key(:images_revisions, :images, :dependent => :delete)
    add_foreign_key(:images_revisions, :revisions, :dependent => :delete)
    add_index(:images_revisions, [:image_id, :revision_id], :unique => true)
    
    
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
      t.string   "role"
    end
    add_foreign_key(:revisions, :users, :column => "editor_id")
    add_index(:users, :email, :unique => true)
  
    User.create(:role=>'admin', 
    :email=>'zlob.o.zlob@gmail.com', 
    :name=>'Валентин Немцев', 
    :duties=>'Разработчик', 
    :password=>'politPass', :password_confirmation=>'politPass')
    
    User.create(:role=>'bot', 
    :email=>'bot@polit-gramota.ru', 
    :name=>'Скрипт импорта', 
    :duties=>'Робот', 
    :password=>'politPass', :password_confirmation=>'politPass')
  
  end

  def self.down
  end
end
