class AddPublicatedToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :publicated, :boolean, :default => false
  end

  def self.down
    remove_column :articles, :publicated
  end
end
