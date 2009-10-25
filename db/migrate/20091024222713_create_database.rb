class CreateDatabase < ActiveRecord::Migration
  def self.up
  
    create_table "articles", :force => true do |t|
      t.integer  "current_revision_id"
      t.integer  "canonical_link_id"
      t.integer  "category_id"
      t.datetime "publication_date"
      t.boolean  "publicated",          :default => false
      t.integer  "revisions_count",     :default => 0
      t.integer  "links_count",         :default => 0
    end

    create_table "categories", :force => true do |t|
      t.integer  "canonical_link_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "title"
      t.boolean  "archived",          :default => false
      t.integer  "position",          :default => 0,     :null => false
      t.integer  "articles_count",    :default => 0
      t.integer  "links_count",       :default => 0
    end

    create_table "images", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "title"
      t.string   "link"
      t.string   "filename",   :null => false
      t.string   "img_type"
    end

    create_table "images_revisions", :id => false, :force => true do |t|
      t.integer "image_id"
      t.integer "revision_id"
    end

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

    create_table "links", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "text"
      t.integer  "linked_id"
      t.string   "linked_type"
      t.integer  "editor_id"
    end

    create_table "quotes", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "text"
      t.string   "author"
    end

    create_table "revisions", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "article_id"
      t.integer  "editor_id"
      t.string   "title"
      t.string   "subtitle"
      t.text     "text"
      t.text     "lead"
      t.text     "text_html"
      t.text     "lead_html"
    end

    create_table "users", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "name",                      :limit => 100, :default => ""
      t.string   "position"
      t.string   "email",                     :limit => 100
      t.string   "crypted_password",          :limit => 40
      t.string   "salt",                      :limit => 40
      t.string   "remember_token",            :limit => 40
      t.datetime "remember_token_expires_at"
      t.string   "role"
    end
  
  
  
    User.create(:role=>'admin', 
    :email=>'zlob.o.zlob@gmail.com', 
    :name=>'Валентин Немцев', 
    :position=>'Разработчик', 
    :password=>'politPass', :password_confirmation=>'politPass')
    
    User.create(:role=>'bot', 
    :email=>'bot@polit-gramota.ru', 
    :name=>'Скрипт импорта', 
    :position=>'Робот', 
    :password=>'politPass', :password_confirmation=>'politPass')
  
  end

  def self.down
  end
end
