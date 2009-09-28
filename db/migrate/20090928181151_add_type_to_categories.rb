class AddTypeToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :cat_type, :string
=begin
  TODO Заменить string на enum
=end
  end

  def self.down
    remove_column :categories, :cat_type

  end
end
