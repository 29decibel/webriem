class AdaptAccountInSss < ActiveRecord::Migration
  def self.up
    rename_column :inner_remittances,:in_account,:in_account_id
    rename_column :inner_remittances,:out_account,:out_account_id
    rename_column :inner_transfers,:in_account,:in_account_id
    rename_column :inner_transfers,:out_account,:out_account_id
  end

  def self.down
  end
end
