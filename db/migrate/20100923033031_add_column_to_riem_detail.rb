class AddColumnToRiemDetail < ActiveRecord::Migration
  def self.up
    add_column :reim_details,:is_split,:integer
  end

  def self.down
    remove_column :reim_details,:is_split
  end
end
