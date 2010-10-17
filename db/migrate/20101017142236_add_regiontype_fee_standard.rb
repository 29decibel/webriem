class AddRegiontypeFeeStandard < ActiveRecord::Migration
  def self.up
    add_column :fee_standards,:region_type_id,:integer
    remove_column :fee_standards,:region_id
  end

  def self.down
    remove_column :fee_standards,:region_type_id
    add_column :fee_standards,:region_id,:integer
  end
end
