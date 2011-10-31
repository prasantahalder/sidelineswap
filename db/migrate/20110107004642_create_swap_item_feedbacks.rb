class CreateSwapItemFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :swap_item_feedbacks do |t|
      t.integer :user_id, :null => false
      t.integer :swap_item_id, :null => false
      t.integer :rating, :null => false
      t.timestamps
    end

    add_index :swap_item_feedbacks, :swap_item_id
    add_index :swap_item_feedbacks, :user_id
  end

  def self.down
    drop_table :swap_item_feedbacks
  end
end
