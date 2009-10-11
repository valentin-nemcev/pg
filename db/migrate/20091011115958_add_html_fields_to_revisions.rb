class AddHtmlFieldsToRevisions < ActiveRecord::Migration
  def self.up
    add_column :revisions, :text_html, :text
    add_column :revisions, :lead_html, :text
  end

  def self.down
    remove_column :revisions, :lead_html
    remove_column :revisions, :text_html
  end
end
