class AddMaxItemsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :max_items, :integer, :default => 100, :null => false
  end

  def self.down
    remove_column :users, :max_items
  end
end
