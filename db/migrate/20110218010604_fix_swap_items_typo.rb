class FixSwapItemsTypo < ActiveRecord::Migration
  def self.up
    rename_column :swap_items, :recepient_id, :recipient_id
  end

  def self.down
    rename_column :swap_items, :recipient_id, :recepient_id
  end
end
