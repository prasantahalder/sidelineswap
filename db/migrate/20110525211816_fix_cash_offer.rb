class FixCashOffer < ActiveRecord::Migration
  def self.up
    change_column :swap_parties, :cash_offer, :decimal, :precision => 6, :scale => 2
  end

  def self.down
    change_column :swap_parties, :cash_offer, :decimal, :precision => 2, :scale => 0
  end
end
