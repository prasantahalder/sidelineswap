class TweakPayments < ActiveRecord::Migration
  def self.up
    remove_column :payments, :orig_payment_id
    remove_column :payments, :paypal_email
    remove_column :payments, :is_fee

    add_column :payments, :fee_amt, :decimal, :precision => 10, :scale => 2, :default => 0.0, :null => false
    add_column :payments, :error_msg, :text
    add_column :payments, :error_id, :integer
    add_column :payments, :paypal_tracking_id, :string

    change_column :payments, :swap_id, :integer, :null => false
    change_column :payments, :recepient_id, :integer, :null => false

    add_index :payments, :paypal_pay_key
    
  end

  def self.down
  end
end
