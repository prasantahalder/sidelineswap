class AddColumnsToSwapStuff < ActiveRecord::Migration
  def self.up
    add_column :swap_parties, :cash_offer, :decimal, :precision => 2
    add_column :swaps, :expiration, :datetime, :null => false
    add_index :swaps, :expiration
  end

  def self.down
    remove_column :swap_parties, :cash_offer
    remove_column :swaps, :expiration
  end
end
