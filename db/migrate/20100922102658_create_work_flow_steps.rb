class CreateWorkFlowSteps < ActiveRecord::Migration
  def self.up
    create_table :work_flow_steps do |t|
      t.integer :dep_id
      t.integer :is_self_dep
      t.integer :duty_id

      t.timestamps
    end
  end

  def self.down
    drop_table :work_flow_steps
  end
end
