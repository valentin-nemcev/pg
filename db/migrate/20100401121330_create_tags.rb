class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end
    add_index(:tags, :name, :unique => true)
    
    create_table "revisions_tags", :id => false, :force => true do |t|
      t.integer "tag_id",   :null => false
      t.integer "revision_id",   :null => true
    end
    add_foreign_key(:revisions_tags, :tags, :dependent => :delete)
    add_foreign_key(:revisions_tags, :revisions, :dependent => :delete)
    add_index(:revisions_tags, [:tag_id, :revision_id], :unique => true)
  end

  def self.down
    drop_table :tags
  end
end
