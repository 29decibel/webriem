class AddCurrencyToJiehui < ActiveRecord::Migration
  def self.up
    add_column :inner_remittances,:currency_id,:integer
  end

  def self.down
    remove_column :inner_remittances,:currency_id
  end
end
