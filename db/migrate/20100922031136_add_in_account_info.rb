class AddInAccountInfo < ActiveRecord::Migration
  def self.up
    add_column :inner_transfers,:in_account_name,:string
    add_column :inner_transfers,:in_account_no,:string
  end

  def self.down
    remove_column :inner_transfers,:in_account_name
    remove_column :inner_transfers,:in_account_name
  end
end
