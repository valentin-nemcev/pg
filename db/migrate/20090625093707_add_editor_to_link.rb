class AddEditorToLink < ActiveRecord::Migration
  def self.up
    add_column :links, :editor_id, :integer
  end

  def self.down
    remove_column :links, :editor_id
  end
end
