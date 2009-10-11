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

ActiveRecord::Schema.define(:version => 20091011115958) do

  create_table "articles", :force => true do |t|
    t.integer  "current_revision_id"
    t.integer  "canonical_link_id"
    t.integer  "category_id"
    t.datetime "publication_date"
  end

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cat_type"
  end

  create_table "images", :force => true do |t|
    t.integer  "article_id"
    t.string   "title"
    t.string   "link"
    t.string   "filename",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "img_type"
  end

  create_table "images_revisions", :id => false, :force => true do |t|
    t.integer "image_id"
    t.integer "revision_id"
  end

  create_table "layout_items", :force => true do |t|
    t.string   "place"
    t.integer  "top"
    t.integer  "left"
    t.integer  "height"
    t.integer  "width"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content_type"
    t.integer  "content_id"
  end

  create_table "links", :force => true do |t|
    t.string   "text"
    t.integer  "linked_id"
    t.string   "linked_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "editor_id"
  end

  create_table "quotes", :force => true do |t|
    t.text     "text"
    t.string   "author"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "revisions", :force => true do |t|
    t.integer  "article_id"
    t.integer  "editor_id"
    t.string   "title"
    t.string   "subtitle"
    t.text     "text"
    t.text     "lead"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "text_html"
    t.text     "lead_html"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "position"
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "role"
    t.decimal  "bug_counter"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
