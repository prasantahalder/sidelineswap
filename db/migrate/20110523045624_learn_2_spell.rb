class Learn2Spell < ActiveRecord::Migration
  def self.up
    rename_column :payments, :recepient_id, :recipient_id
  end

  def self.down
    rename_column :payments, :recipient_id, :recepient_id
  end
end
