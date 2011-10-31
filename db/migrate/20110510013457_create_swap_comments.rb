class CreateSwapComments < ActiveRecord::Migration
  def self.up

    create_table :swap_comments do |t|
      t.integer :swap_id, :null => false
      t.integer :user_id, :null => false
      t.text :comment

      t.timestamps
    end
    add_index :swap_comments, :swap_id
  end

  def self.down
    drop_table :swap_comments
  end
end
