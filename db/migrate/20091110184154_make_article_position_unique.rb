class MakeArticlePositionUnique < ActiveRecord::Migration
  def self.up
    cats = Category.all(:order => 'position ASC, archived ASC')
    1.upto(cats.size) do |i|
        cats[i-1].update_attribute('position', i)
    end
    change_column :categories, :position, :integer, :null => true
    add_index(:categories, [:archived, :position], :unique => true)
  end

  def self.down
    change_column :categories, :position, :integer, :null => false
    remove_index :categories, [:archived, :position]
    
  end
end
