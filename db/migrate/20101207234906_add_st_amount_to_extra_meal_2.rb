class AddStAmountToExtraMeal2 < ActiveRecord::Migration
  def self.up
    remove_column :rd_work_meals,:st_amount
    add_column :rd_extra_work_meals,:st_amount,:decimal,:precision => 8,  :scale => 2
  end

  def self.down
  end
end
