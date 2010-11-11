class RemoteHrFiAmount < ActiveRecord::Migration
  def self.up
    remove_column :rd_common_transports,:note
    remove_column :rd_common_transports,:hr_amount
    remove_column :rd_common_transports,:fi_amount   
    remove_column :common_riems,:hr_amount
    remove_column :common_riems,:fi_amount   
  end

  def self.down
  end
end
