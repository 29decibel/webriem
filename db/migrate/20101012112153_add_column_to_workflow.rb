class AddColumnToWorkflow < ActiveRecord::Migration
  def self.up
    add_column :work_flow_steps,:max_amount,:decimal,:precision => 8, :scale => 2
  end

  def self.down
    remove_column :work_flow_steps,:max_amount
  end
end
