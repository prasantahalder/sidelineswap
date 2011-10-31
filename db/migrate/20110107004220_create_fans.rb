class CreateFans < ActiveRecord::Migration
  def self.up
    create_table :fans do |t|
      t.integer :user_id, :null => false
      t.integer :fannable_id, :null => false
      t.string :fannable_type, :null => false

      t.timestamps
    end

    add_index :fans, :user_id
    add_index :fans, [:fannable_type, :fannable_id]
  end

  def self.down
    drop_table :fans
  end
end
