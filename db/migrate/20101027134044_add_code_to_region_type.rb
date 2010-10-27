class AddCodeToRegionType < ActiveRecord::Migration
  def self.up
    add_column :region_types,:code,:string
  end

  def self.down
    remove_column :region_types,:code
  end
end
