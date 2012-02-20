class CreateNavigation < ActiveRecord::Migration
  def self.up
    create_table :navigation do |t|
      t.string :name, :null => false
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :navigation
  end
end
