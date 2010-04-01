class AddImages < ActiveRecord::Migration
  def self.up
    create_table "images", :force => true do |t|
      t.timestamps
    end
    add_column :images, :image_file_name, :string
    add_column :images, :image_content_type, :string
    add_column :images, :image_file_size, :integer
    
    create_table "images_revisions", :id => false, :force => true do |t|
      t.integer "image_id",   :null => false
      t.integer "revision_id",   :null => true
    end
    add_foreign_key(:images_revisions, :images, :dependent => :delete)
    add_foreign_key(:images_revisions, :revisions, :dependent => :delete)
    add_index(:images_revisions, [:image_id, :revision_id], :unique => true)
  end

  def self.down
  end
end
