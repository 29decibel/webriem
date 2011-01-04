class ChangeColumn2 < ActiveRecord::Migration
  def self.up
    change_column :rd_lodgings,:start_date,:datetime
    change_column :rd_lodgings,:end_date,:datetime
  end

  def self.down
  end
end
