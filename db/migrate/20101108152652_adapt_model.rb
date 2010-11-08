class AdaptModel < ActiveRecord::Migration
  def self.up
    add_column :rd_work_meals,:dep_id,:integer
    add_column :rd_work_meals,:project_id,:integer
    add_column :rd_common_transports,:dep_id,:integer
    add_column :rd_common_transports,:project_id,:integer
    add_column :rd_benefits,:hr_amount,:decimal,:precision=>8,:scale=>2
    add_column :rd_benefits,:fi_amount,:decimal,:precision=>8,:scale=>2
    remove_column :rd_work_meals,:hr_amount
    remove_column :rd_work_meals,:fi_amount
  end

  def self.down
  end
end
