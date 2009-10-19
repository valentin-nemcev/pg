class AddPositionToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :position, :integer, :null => false, :default => 0
    Category.all.each_with_index {|cat, i| cat.update_attribute(:position, i)}
  end

  def self.down
    remove_column :categories, :position
  end
end
