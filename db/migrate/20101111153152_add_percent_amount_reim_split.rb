class AddPercentAmountReimSplit < ActiveRecord::Migration
  def self.up
    add_column :reim_split_details,:percent_amount,:decimal,:precision=>8,:scale=>2
  end

  def self.down
    remove_column :reim_split_details,:percent_amount
  end
end
