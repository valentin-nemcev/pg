class AddCounterToTags < ActiveRecord::Migration
  def self.up
  add_column :tags, :articles_count, :integer, :default => 0
  Tag.reset_column_information
  Tag.find(:all).each do |c|
  c.update_attribute :articles_count, c.articles.length
  end
  end
  def self.down
  remove_column :tags, :articles_count
  end
end
