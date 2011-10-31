class AddHitsToItemsAndLockers < ActiveRecord::Migration
  def self.up
    add_column :items, :hits, :integer, :limit => 5, :null=> false
    add_column :items, :last_hit, :datetime
    add_column :lockers, :hits, :integer, :limit => 5, :null=> false
    add_column :lockers, :last_hit, :datetime

    add_index :items, [:last_hit, :hits]
    add_index :lockers, [:last_hit, :hits]
    add_index :items, :hits
    add_index :lockers, :hits
  end

  def self.down
    remove_column :items, [:hits, :last_hit]
    remove_column :lockers, [:hits, :last_hit]
  end
end
