class MoreTeamStuff < ActiveRecord::Migration
  def self.up
    create_table :teams_user_profiles, :id => false do |t|
      t.integer :user_profile_id, :null => false
      t.integer :team_id, :null => false
    end

    add_index :teams_user_profiles, [:team_id, :user_profile_id], :unique => true
    add_index :teams_user_profiles, :user_profile_id

    add_column :items, :team_id, :integer
    add_index :items, :team_id
  end

  def self.down
    drop_table :teams_user_profiles
    remove_column :items, :team_id
  end
end
