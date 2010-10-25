class AddFeeFs < ActiveRecord::Migration
  def self.up
    add_column :fee_standards,:fee_id,:integer
  end

  def self.down
    remove_column :fee_standards,:fee_id
  end
end
