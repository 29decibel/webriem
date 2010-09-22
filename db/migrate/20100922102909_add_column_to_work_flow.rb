class AddColumnToWorkFlow < ActiveRecord::Migration
  def self.up
    add_column :work_flow_steps,:work_flow_id,:integer
  end

  def self.down
    remove_column :work_flow_steps,:work_flow_id
  end
end
