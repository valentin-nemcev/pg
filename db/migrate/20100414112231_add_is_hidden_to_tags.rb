class AddIsHiddenToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :is_hidden, :boolean, :default => false
  end

  def self.down
    remove_column :tags, :is_hidden
  end
end
