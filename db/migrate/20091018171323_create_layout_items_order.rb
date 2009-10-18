class CreateLayoutItemsOrder < ActiveRecord::Migration
  def self.up
    create_table :layout_items_to_content do |t|
      t.integer :layout_item_id
      t.integer :article_id
      t.integer :position, :null => false
    end
  end

  def self.down
    drop_table :layout_items_to_content
    remove_column :layout_items, :content_type  
    remove_column :layout_items, :content_id  
  end
end
