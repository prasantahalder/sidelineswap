class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :street_1, :null => false
      t.string :street_2
      t.string :city, :null => false
      t.string :state, :limit => 2, :null => false
      t.string :zip, :limit => 10, :null => false
      t.string :phone, :limit => 10
      t.boolean :business_address, :null => false, :default => false

      t.timestamps
    end

    add_column :swap_parties, :ship_address_id, :integer, :null => false
  end

  def self.down
    drop_table :addresses
    remove_column :swap_parties, :ship_address_id
  end
end
