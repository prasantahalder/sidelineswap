class AddConfirmNoteToSwapParties < ActiveRecord::Migration
  def self.up
    add_column :swap_parties, :confirm_note, :text
  end

  def self.down
    remove_column :swap_parties, :confirm_note
  end
end
