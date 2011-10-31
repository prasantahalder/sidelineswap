class AddFieldsToStore < ActiveRecord::Migration
  def self.up
    add_column :stores, :location, :string
    add_column :stores, :website, :string
    add_column :stores, :state, :string
    add_column :stores, :established_in, :string
    add_column :stores, :gear_designed_by, :string
    add_column :stores, :address_id, :string
  end

  def self.down
  end
end
