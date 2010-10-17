class AddBusinessType < ActiveRecord::Migration
  def self.up
    add_column :fee_standards,:business_type_id,:integer
    add_column :subjects,:business_type_id,:integer
  end

  def self.down
    remove_column :fee_standards,:business_type_id
    remove_column :subjects,:business_type_id
  end
end
