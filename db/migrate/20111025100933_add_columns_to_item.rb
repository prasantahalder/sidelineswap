class AddColumnsToItem < ActiveRecord::Migration
  def self.up
     add_column :items, :size, :string
     add_column :items, :shipping_price, :string
  end

  def self.down
  end
end
