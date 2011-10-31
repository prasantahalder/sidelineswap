class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.string :name, :null => false
      t.string :city
      t.string :state
      t.string :country, :null => false

      t.timestamps
    end

    add_index :teams, :name
    add_index :teams, :country
  end

  def self.down
    drop_table :teams
  end
end
