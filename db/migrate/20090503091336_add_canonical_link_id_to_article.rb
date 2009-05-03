class AddCanonicalLinkIdToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :canonical_link_id, :integer
  end

  def self.down
    remove_column :articles, :canonical_link_id
  end
end
