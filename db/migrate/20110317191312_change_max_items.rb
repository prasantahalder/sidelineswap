class ChangeMaxItems < ActiveRecord::Migration
  def self.up
    remove_column :users, :max_items
    add_column :lockers, :max_items, :integer, :default => 15, :null => false
  end

  def self.down
    remove_column :lockers, :max_items
    add_column :users, :max_items, :integer, :default => 15, :null => false
  end
end
