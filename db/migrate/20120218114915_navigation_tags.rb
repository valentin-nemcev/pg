class NavigationTags < ActiveRecord::Migration
  def self.up
    create_table :navigation_tags do |t|
      t.integer :tag_id
      t.integer :navigation_id
      t.integer :position, :null => false
    end

    add_foreign_key(:navigation_tags, :tags, :dependent => :delete)
    add_foreign_key(:navigation_tags, :navigation, :dependent => :delete)
    add_index :navigation_tags, [:tag_id, :navigation_id], :unique => true

  end

  def self.down
    drop_table :navigation_tags
  end
end
