class CreateLayoutItems < ActiveRecord::Migration
  def self.up
    create_table :layout_items do |t|
      t.string :place
      t.integer :top
      t.integer :left
      t.integer :height
      t.integer :width

      t.timestamps
    end
  end

  def self.down
    drop_table :layout_items
  end
end
