class AddCounters < ActiveRecord::Migration
  def self.up
    add_column :articles, :revisions_count, :integer, :default => 0
    add_column :articles, :links_count, :integer, :default => 0
    Article.reset_column_information
    Article.find(:all).each do |r|
      Article.update_counters r.id, :revisions_count => r.revisions.count
      Article.update_counters r.id, :links_count => r.links.count
    end  
    add_column :categories, :articles_count, :integer, :default => 0
    add_column :categories, :links_count, :integer, :default => 0
    Category.reset_column_information
    Category.find(:all).each do |r|
      Category.update_counters r.id, :articles_count => r.articles.count
      Category.update_counters r.id, :links_count => r.links.count
    end
  end

  def self.down
    remove_column :articles, :revisions_count
    remove_column :articles, :links_count
    remove_column :categories, :articles_count
    remove_column :categories, :links_count
  end
end
