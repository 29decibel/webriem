class AddStAmountToExtraMeal < ActiveRecord::Migration
  def self.up
    add_column :rd_work_meals,:st_amount,:decimal,:precision => 8,  :scale => 2
  end

  def self.down
  end
end
