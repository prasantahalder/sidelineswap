class RemoveColumnFromStore < ActiveRecord::Migration
  def self.up
    remove_column :stores, :state
    remove_column :stores, :website
  end

  def self.down
  end
end
