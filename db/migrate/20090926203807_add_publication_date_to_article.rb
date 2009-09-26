class AddPublicationDateToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :publication_date, :datetime
    remove_column :revisions, :publicated
    remove_column :revisions, :publication_date
  end

  def self.down
    remove_column :articles, :publication_date
    add_column :revisions, :publicated, :boolean
    add_column :revisions, :publication_date, :datetime
  end
end
