class RenameShipAddress < ActiveRecord::Migration
  def self.up
    rename_column(:swap_parties, :ship_address_id, :shipping_address_id)
  end

  def self.down
    rename_column(:swap_parties, :shipping_address_id, :ship_address_id)
  end
end
