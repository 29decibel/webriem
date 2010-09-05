class RenameColumnOfFee < ActiveRecord::Migration
  def self.up
    rename_column :fees,:parent_fee,:parent_fee_id
  end

  def self.down
    rename_column :fees,:parent_fee_id,:parent_fee
  end
end
