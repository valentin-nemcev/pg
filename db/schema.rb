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

ActiveRecord::Schema.define(:version => 20091110184154) do

  create_table "articles", :force => true do |t|
    t.integer  "current_revision_id"
    t.integer  "canonical_link_id"
    t.integer  "category_id",                            :null => false
    t.datetime "publication_date"
    t.boolean  "publicated",          :default => false
    t.integer  "revisions_count",     :default => 0
    t.integer  "links_count",         :default => 0
  end

  add_index "articles", ["canonical_link_id"], :name => "articles_canonical_link_id_fk"
  add_index "articles", ["category_id"], :name => "articles_category_id_fk"
  add_index "articles", ["current_revision_id"], :name => "articles_current_revision_id_fk"

  create_table "categories", :force => true do |t|
    t.integer  "canonical_link_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",                                :null => false
    t.boolean  "archived",          :default => false
    t.integer  "position",          :default => 0
    t.integer  "articles_count",    :default => 0
    t.integer  "links_count",       :default => 0
  end

  add_index "categories", ["archived", "position"], :name => "index_categories_on_archived_and_position", :unique => true
  add_index "categories", ["canonical_link_id"], :name => "categories_canonical_link_id_fk"

  create_table "images", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "filename",                                                                    :null => false
    t.enum     "layout_type", :limit => [:face, :banner, :photo, :image], :default => :image
    t.integer  "crop_top",                                                :default => 0,      :null => false
    t.integer  "crop_left",                                               :default => 0,      :null => false
    t.integer  "crop_bottom",                                             :default => 0,      :null => false
    t.integer  "crop_right",                                              :default => 0,      :null => false
  end

  add_index "images", ["filename"], :name => "index_images_on_filename", :unique => true

  create_table "images_revisions", :id => false, :force => true do |t|
    t.integer "image_id",    :null => false
    t.integer "revision_id"
  end

  add_index "images_revisions", ["image_id", "revision_id"], :name => "index_images_revisions_on_image_id_and_revision_id", :unique => true
  add_index "images_revisions", ["revision_id"], :name => "images_revisions_revision_id_fk"

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

  create_table "quotes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "text"
    t.string   "author"
  end

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

  add_foreign_key "articles", "categories", :name => "articles_category_id_fk"
  add_foreign_key "articles", "links", :name => "articles_canonical_link_id_fk", :column => "canonical_link_id", :dependent => :nullify
  add_foreign_key "articles", "revisions", :name => "articles_current_revision_id_fk", :column => "current_revision_id", :dependent => :nullify

  add_foreign_key "categories", "links", :name => "categories_canonical_link_id_fk", :column => "canonical_link_id", :dependent => :nullify

  add_foreign_key "images_revisions", "images", :name => "images_revisions_image_id_fk", :dependent => :delete
  add_foreign_key "images_revisions", "revisions", :name => "images_revisions_revision_id_fk", :dependent => :delete

  add_foreign_key "layout_items", "articles", :name => "layout_items_article_id_fk", :dependent => :delete
  add_foreign_key "layout_items", "layout_cells", :name => "layout_items_layout_cell_id_fk", :dependent => :delete

  add_foreign_key "links", "articles", :name => "links_article_id_fk"
  add_foreign_key "links", "categories", :name => "links_category_id_fk"

  add_foreign_key "revisions", "articles", :name => "revisions_article_id_fk"
  add_foreign_key "revisions", "users", :name => "revisions_editor_id_fk", :column => "editor_id"

end
