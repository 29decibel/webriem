class AddFeeIdToEx < ActiveRecord::Migration
  def self.up
     add_column :extra_work_standards,:fee_id,:integer
  end

  def self.down
    remove_column :extra_work_standards,:fee_id
  end
end
