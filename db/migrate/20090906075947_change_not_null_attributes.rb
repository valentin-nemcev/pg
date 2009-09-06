class ChangeNotNullAttributes < ActiveRecord::Migration
  def self.up
    execute 'DELETE FROM images WHERE filename IS NULL'
    change_column(:images, :filename, :string, :null => false)
  end

  def self.down
    change_column(:images, :filename, :string, :null => true)
  end
end
