class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :swap_id
      t.integer :user_id
      t.integer :recepient_id
      t.integer :orig_payment_id
      t.string :paypal_correlation_id
      t.string :paypal_pay_key
      t.string :paypal_txn_id
      t.string :paypal_payment_status, :null => false
      t.string :paypal_email
      t.decimal :amt, :precision => 10, :scale => 2, :default => 0.0,   :null => false
      t.boolean :is_fee, :null => false
      t.boolean :successful, :null => false

      t.timestamps
    end

    add_index :payments, :orig_payment_id
    add_index :payments, :swap_id
    add_index :payments, :user_id
    add_index :payments, :recepient_id
    add_index :payments, :successful
    add_index :payments, :paypal_txn_id
    add_index :payments, :paypal_payment_status
  end

  def self.down
    drop_table :payments
  end
end
