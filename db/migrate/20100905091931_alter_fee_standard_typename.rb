class AlterFeeStandardTypename < ActiveRecord::Migration
  def self.up
    rename_column :fee_standards,:type,:busitype
  end

  def self.down
    rename_column :fee_standards,:busitype,:type
  end
end
