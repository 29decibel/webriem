class AddPlaceToTravel < ActiveRecord::Migration
  def self.up
    add_column :rd_travels,:custom_place,:string
    add_column :rd_lodgings,:custom_place,:string
  end

  def self.down
  end
end
