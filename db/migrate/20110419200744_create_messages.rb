class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :to_user_id, :null => false
      t.integer :from_user_id
      t.boolean :system, :null => false, :default => false
      t.boolean :unread, :null => false, :default => true
      t.string :subject, :null => false
      t.text :body
      t.timestamps
    end

    add_index :messages, [:to_user_id, :system]
    add_index :messages, :created_at
  end

  def self.down
    drop_table :messages
  end
end
