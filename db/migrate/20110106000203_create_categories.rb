class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name, :null => false
      t.boolean :selectable, :null => false, :default => true
      t.string :ancestry

      t.timestamps
    end

    add_index :categories, :selectable
    add_index :categories, :ancestry
    
  end

  def self.down
    drop_table :categories
  end
end
