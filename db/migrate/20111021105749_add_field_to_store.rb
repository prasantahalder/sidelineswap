class AddFieldToStore < ActiveRecord::Migration
  def self.up
    add_column :stores, :cause, :text
  end

  def self.down
  end
end
