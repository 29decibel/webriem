class AdaptAccountInRiem < ActiveRecord::Migration
  def self.up
    add_column :inner_remittances,:in_account,:integer
    remove_column :inner_remittances,:in_account_name
    remove_column :inner_remittances,:in_account_no
    add_column :inner_remittances,:in_amount_after,:decimal,:precision => 8, :scale => 2
    #add column to transfer
    add_column :inner_transfers,:in_account,:integer
    remove_column :inner_transfers,:in_account_name
    remove_column :inner_transfers,:in_account_no
    add_column :inner_transfers,:in_amount_after,:decimal,:precision => 8, :scale => 2
  end

  def self.down
  end
end
