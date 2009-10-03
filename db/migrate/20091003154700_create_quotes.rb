class CreateQuotes < ActiveRecord::Migration
  def self.up
    create_table :quotes do |t|
      t.column :text, :text
      t.column :author, :string

      t.timestamps
    end
  end

  def self.down
    drop_table :quotes
  end
end
