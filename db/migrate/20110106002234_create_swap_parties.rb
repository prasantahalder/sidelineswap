class CreateSwapParties < ActiveRecord::Migration
  def self.up
    create_table :swap_parties do |t|
      t.integer :swap_id, :null => false
      t.integer :user_id, :null => false
      t.integer :response, :null => false, :default => 0
      t.datetime :responded_at

      t.timestamps
    end

    add_index :swap_parties, :swap_id
    add_index :swap_parties, :user_id
    
  end

  def self.down
    drop_table :swap_parties
  end
end
