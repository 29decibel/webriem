class AddDateToRdLodging < ActiveRecord::Migration
  def self.up
    remove_column :rd_lodgings,:lodging_date
    add_column :rd_lodgings,:start_date,:date
    add_column :rd_lodgings,:end_date,:date
    add_column :rd_lodgings,:st_amount,:decimal,:precision=>8,:scale=>2
    remove_column :rd_travels,:fee_standard_id
    add_column :rd_travels,:st_amount,:decimal,:precision=>8,:scale=>2
  end

  def self.down
  end
end
