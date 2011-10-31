class CreateSwapItems < ActiveRecord::Migration
  def self.up
    create_table :swap_items do |t|
      t.integer :swap_id, :null => false
      t.integer :item_id, :null => false
      t.integer :quantity, :null => false, :default => 1
      t.integer :recepient_id, :null => false

      t.timestamps
    end

    add_index :swap_items, :swap_id
    add_index :swap_items, :item_id
    add_index :swap_items, :recepient_id
  end

  def self.down
    drop_table :swap_items
  end
end
