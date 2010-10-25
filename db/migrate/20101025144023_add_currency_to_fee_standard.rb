class AddCurrencyToFeeStandard < ActiveRecord::Migration
  def self.up
    add_column :fee_standards,:currency_id,:integer
  end

  def self.down
    remove_column :fee_standards,:currency_id
  end
end
