class AddConfirmedToSwapParties < ActiveRecord::Migration
  def self.up
  	add_column :swap_parties, :confirm, :boolean
  	add_index :swap_parties, :confirm
  end

  def self.down
  	remove_column :swap_parties, :confirm
  end
end
