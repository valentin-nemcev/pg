class AddContentToLayoutItems < ActiveRecord::Migration
  def self.up
    add_column :layout_items, :content_type, :string
    add_column :layout_items, :content_id, :integer
  end

  def self.down
    remove_column :layout_items, :content_id
    remove_column :layout_items, :content_type
  end
end
