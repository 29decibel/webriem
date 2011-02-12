class AddFeeCode < ActiveRecord::Migration
  def self.up
    add_column :fee_code_matches,:fee_code,:string
  end

  def self.down
  end
end
