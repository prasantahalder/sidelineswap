class CreateSwaps < ActiveRecord::Migration
  def self.up
    create_table :swaps do |t|
      t.string :name
      t.boolean :completed

      t.timestamps
    end
  end

  def self.down
    drop_table :swaps
  end
end
