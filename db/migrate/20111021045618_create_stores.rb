class CreateStores < ActiveRecord::Migration
  def self.up
    create_table :stores do |t|
      t.column :organizationname,                     :string, :limit => 40
      t.column :user_id,                     :string, :limit => 40
      t.timestamps
    end
  end

  def self.down
    drop_table :stores
  end
end
