class AddTypeToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :img_type, :string
  end

  def self.down
    remove_column :images, :img_type
  end
end
