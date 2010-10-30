class AddRegionTypeToRd < ActiveRecord::Migration
  def self.up
    add_column :rd_travels,:region_type_id,:integer
    add_column :rd_lodgings,:region_type_id,:integer
  end

  def self.down
    remove_column :rd_travels,:region_type_id
    remove_column :rd_lodgings,:region_type_id
  end
end
