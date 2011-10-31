class CreateItemComments < ActiveRecord::Migration
  def self.up
    create_table :item_comments do |t|
      t.integer :item_id
      t.integer :user_id
      t.text :comment

      t.timestamps
    end

    add_index :item_comments, :item_id
  end

  def self.down
    drop_table :item_comments
  end
end
