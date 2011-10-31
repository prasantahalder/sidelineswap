class SetDefaultForHits < ActiveRecord::Migration
  def self.up
    change_column_default(:lockers, :hits, 0)
    change_column_default(:items, :hits, 0)
  end

  def self.down
  end
end
