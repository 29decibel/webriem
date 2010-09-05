class AddColumnToFee < ActiveRecord::Migration
  def self.up
    add_column :fees,:parent_fee,:integer
  end

  def self.down
    remove_column :fees,:parent_fee
  end
end
