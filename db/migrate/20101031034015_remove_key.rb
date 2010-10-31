class RemoveKey < ActiveRecord::Migration
  def self.up
    drop_table :duties_work_flows
    create_table :duties_work_flows,:force => true, :id => false do |t|
      t.integer :work_flow_id
      t.integer :duty_id

      t.timestamps
    end
    
  end

  def self.down
  end
end
