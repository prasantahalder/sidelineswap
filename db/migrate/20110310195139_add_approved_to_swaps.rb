class AddApprovedToSwaps < ActiveRecord::Migration
  def self.up
    add_column :swaps, :agreed, :boolean, :default => false, :null => false
    add_index :swaps, :agreed
  end

  def self.down
    remove_column :swaps, :agreed
  end
end
