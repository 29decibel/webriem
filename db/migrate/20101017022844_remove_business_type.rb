class RemoveBusinessType < ActiveRecord::Migration
  def self.up
    remove_column :fee_standards,:busitype
    remove_column :subjects,:busitype
  end

  def self.down
  end
end
