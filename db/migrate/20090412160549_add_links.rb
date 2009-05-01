class AddLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string :text
      t.references :linkable, :polymorphic => true
      t.timestamps
    end
    remove_column :revisions, :link
  end

  def self.down
    drop_table :links
  end
end
