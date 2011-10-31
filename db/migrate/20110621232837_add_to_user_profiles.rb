class AddToUserProfiles < ActiveRecord::Migration
  def self.up
	add_column :user_profiles, :hometown, :string
	add_column :user_profiles, :schools, :string
	add_column :user_profiles, :club_teams, :string
	add_column :user_profiles, :sports, :string
	add_column :user_profiles, :favorite_teams, :string
	add_column :user_profiles, :favorite_brand, :string
  end

  def self.down
	remove_column :user_profiles, :hometown
	remove_column :user_profiles, :schools
	remove_column :user_profiles, :club_teams
	remove_column :user_profiles, :sports
	remove_column :user_profiles, :favorite_teams
	remove_column :user_profiles, :favorite_brand
  end
end
