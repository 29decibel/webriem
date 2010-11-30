class AdaptTimeToDatetimec < ActiveRecord::Migration
  def self.up
    change_column :rd_common_transports,:start_time,:datetime
    change_column :rd_common_transports,:end_time,:datetime
    change_column :rd_extra_work_cars,:start_time,:datetime
    change_column :rd_extra_work_cars,:end_time,:datetime
    change_column :rd_extra_work_meals,:start_time,:datetime
    change_column :rd_extra_work_meals,:end_time,:datetime
    change_column :rd_transports,:start_date,:datetime
    change_column :rd_transports,:end_date,:datetime
  end

  def self.down
  end
end
