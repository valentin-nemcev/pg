class CreateRedirects < ActiveRecord::Migration
  def self.up
    create_table :redirects, :force => true do |t|
      t.timestamps
      t.string   :from, :null => false
      t.string   :to 
    end
    add_index(:redirects, :from, :unique => true)
  end

  def self.down
    drop_table :redirects
  end
end
