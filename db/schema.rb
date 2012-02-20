# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120220132956) do

  create_table "articles", :force => true do |t|
    t.integer  "canonical_link_id"
    t.datetime "publication_date"
    t.boolean  "is_publicated",         :default => false, :null => false
    t.string   "uri",                                      :null => false
    t.string   "title",                                    :null => false
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
    t.integer  "comments_count",        :default => 0
    t.boolean  "dont_export_to_yandex", :default => false
  end

  add_index "articles", ["legacy_id"], :name => "index_articles_on_legacy_id", :unique => true
  add_index "articles", ["legacy_uri"], :name => "index_articles_on_legacy_uri", :unique => true
  add_index "articles", ["uri"], :name => "index_articles_on_uri", :unique => true

  create_table "articles_images", :id => false, :force => true do |t|
    t.integer "image_id",   :null => false
    t.integer "article_id"
  end

  add_index "articles_images", ["article_id"], :name => "articles_images_article_id_fk"
  add_index "articles_images", ["image_id", "article_id"], :name => "index_articles_images_on_image_id_and_article_id", :unique => true

  create_table "articles_tags", :id => false, :force => true do |t|
    t.integer "tag_id",     :null => false
    t.integer "article_id"
  end

  add_index "articles_tags", ["article_id"], :name => "articles_tags_article_id_fk"
  add_index "articles_tags", ["tag_id", "article_id"], :name => "index_articles_tags_on_tag_id_and_article_id", :unique => true

  create_table "categories", :force => true do |t|
    t.integer  "canonical_link_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",                                :null => false
    t.boolean  "archived",          :default => false
    t.integer  "position",          :default => 0
    t.integer  "articles_count",    :default => 0
    t.integer  "links_count",       :default => 0
    t.boolean  "hidden",            :default => false
  end

  add_index "categories", ["archived", "position"], :name => "index_categories_on_archived_and_position", :unique => true
  add_index "categories", ["canonical_link_id"], :name => "categories_canonical_link_id_fk"

  create_table "comments", :force => true do |t|
    t.integer  "article_id",       :null => false
    t.datetime "publication_date"
    t.string   "author_name"
    t.boolean  "is_highlighted"
    t.text     "body"
    t.text     "body_html"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["article_id"], :name => "comments_article_id_fk"

  create_table "images", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "uri"
    t.string   "legacy_uri"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.string   "legacy_file_name"
  end

  add_index "images", ["legacy_file_name"], :name => "index_images_on_legacy_file_name", :unique => true
  add_index "images", ["legacy_uri"], :name => "index_images_on_legacy_uri", :unique => true
  add_index "images", ["uri"], :name => "index_images_on_uri", :unique => true

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

  add_index "layout_items", ["article_id"], :name => "layout_items_article_id_fk"
  add_index "layout_items", ["layout_cell_id"], :name => "layout_items_layout_cell_id_fk"

  create_table "links", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "text",        :null => false
    t.integer  "category_id"
    t.integer  "article_id"
  end

  add_index "links", ["article_id"], :name => "links_article_id_fk"
  add_index "links", ["category_id"], :name => "links_category_id_fk"
  add_index "links", ["text"], :name => "index_links_on_text", :unique => true

  create_table "navigation", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "navigation_tags", :force => true do |t|
    t.integer "tag_id"
    t.integer "navigation_id"
    t.integer "position",      :null => false
  end

  add_index "navigation_tags", ["navigation_id"], :name => "navigation_tags_navigation_id_fk"
  add_index "navigation_tags", ["tag_id", "navigation_id"], :name => "index_navigation_tags_on_tag_id_and_navigation_id", :unique => true

  create_table "quotes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "text"
    t.string   "author"
  end

  create_table "redirects", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "from",       :null => false
    t.string   "to"
  end

  add_index "redirects", ["from"], :name => "index_redirects_on_from", :unique => true

  create_table "revisions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "article_id", :null => false
    t.integer  "editor_id",  :null => false
    t.string   "title"
    t.string   "subtitle"
    t.text     "text"
    t.text     "lead"
    t.text     "text_html"
    t.text     "lead_html"
  end

  add_index "revisions", ["article_id"], :name => "revisions_article_id_fk"
  add_index "revisions", ["editor_id"], :name => "revisions_editor_id_fk"

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "name",                              :null => false
    t.string   "uri",                               :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "articles_count", :default => 0
    t.boolean  "is_hidden",      :default => false
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true
  add_index "tags", ["uri"], :name => "index_tags_on_uri", :unique => true

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                      :limit => 100,                     :default => ""
    t.string   "duties"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.enum     "role",                      :limit => [:admin, :editor, :bot], :default => :editor
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  add_foreign_key "articles_images", "articles", :name => "articles_images_article_id_fk", :dependent => :delete
  add_foreign_key "articles_images", "images", :name => "articles_images_image_id_fk", :dependent => :delete

  add_foreign_key "articles_tags", "articles", :name => "articles_tags_article_id_fk", :dependent => :delete
  add_foreign_key "articles_tags", "tags", :name => "articles_tags_tag_id_fk", :dependent => :delete

  add_foreign_key "categories", "links", :name => "categories_canonical_link_id_fk", :column => "canonical_link_id", :dependent => :nullify

  add_foreign_key "comments", "articles", :name => "comments_article_id_fk"

  add_foreign_key "layout_items", "articles", :name => "layout_items_article_id_fk", :dependent => :delete
  add_foreign_key "layout_items", "layout_cells", :name => "layout_items_layout_cell_id_fk", :dependent => :delete

  add_foreign_key "links", "articles", :name => "links_article_id_fk"
  add_foreign_key "links", "categories", :name => "links_category_id_fk"

  add_foreign_key "navigation_tags", "navigation", :name => "navigation_tags_navigation_id_fk", :dependent => :delete
  add_foreign_key "navigation_tags", "tags", :name => "navigation_tags_tag_id_fk", :dependent => :delete

  add_foreign_key "revisions", "articles", :name => "revisions_article_id_fk"
  add_foreign_key "revisions", "users", :name => "revisions_editor_id_fk", :column => "editor_id"

end
