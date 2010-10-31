class AddReleTable < ActiveRecord::Migration
  def self.up
    create_table :duties_work_flows do |t|
      t.integer :work_flow_id
      t.integer :duty_id

      t.timestamps
    end
  end

  def self.down
    drop_table :duties_work_flows
  end
end
