class AddBugCounterToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :bug_counter, :integer
  end

  def self.down
    remove_column :users, :bug_counter
  end
end
