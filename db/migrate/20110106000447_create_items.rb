class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name, :null => false
      t.decimal :weight_lbs
      t.decimal :price
      t.integer :category_id,        :null => false
      t.integer :user_id, :null => false
      t.boolean :swapped, :null => false, :default => false
      t.boolean :available, :null => false, :default => true

      t.timestamps
    end

    add_index :items, :available
    add_index :items, :name
    add_index :items, :price
    add_index :items, :category_id
    add_index :items, :user_id

  end

  def self.down
    drop_table :items
  end
end
