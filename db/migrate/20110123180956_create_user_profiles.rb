class CreateUserProfiles < ActiveRecord::Migration
  def self.up
    create_table :user_profiles do |t|
      t.integer :user_id, :null => false
      t.text :bio
      t.date :birth_date
      t.string :gender
      t.string :location
      t.string :website

      t.timestamps
    end

    add_index :user_profiles, :user_id
    add_index :user_profiles, :birth_date
  end

  def self.down
    drop_table :user_profiles
  end
end
