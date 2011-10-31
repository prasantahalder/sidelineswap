class CreateLockers < ActiveRecord::Migration
  def self.up
    create_table :lockers do |t|
      t.integer :user_id, :null => false
      t.string :name, :null => false

      t.timestamps
    end

    add_column :items, :locker_id, :integer
    add_index :lockers, :user_id
    add_index :lockers, :name
    add_index :items, :locker_id
  end

  def self.down
    drop_table :lockers
    remove_column :items, :locker_id
  end
end
