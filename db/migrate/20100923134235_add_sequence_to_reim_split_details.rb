class AddSequenceToReimSplitDetails < ActiveRecord::Migration
  def self.up
    add_column :reim_split_details,:sequence,:integer
  end

  def self.down
    remove_column :reim_split_details,:sequence
  end
end
