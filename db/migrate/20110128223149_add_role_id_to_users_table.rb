class AddRoleIdToUsersTable < ActiveRecord::Migration
  def self.up
    add_column :users, :role_id, :integer
    add_index :users, :role_id
  end

  def self.down
    remove_column :users, :role_id
  end
end
