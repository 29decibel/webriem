class CreateWorkFlows < ActiveRecord::Migration
  def self.up
    create_table :work_flows do |t|
      t.string :name
      t.string :doc_types

      t.timestamps
    end
  end

  def self.down
    drop_table :work_flows
  end
end
