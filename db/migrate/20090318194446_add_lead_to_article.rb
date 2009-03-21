class AddLeadToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :lead, :text
  end

  def self.down
    remove_column :articles, :lead
  end
end
