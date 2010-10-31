class AddLegacyFileNameToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :legacy_file_name, :string
    add_index :images, :legacy_file_name, :unique => true
  end

  def self.down
    remove_index :images, :legacy_file_name
    remove_column :images, :legacy_file_name
  end
end
