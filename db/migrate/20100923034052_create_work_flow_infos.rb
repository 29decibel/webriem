class CreateWorkFlowInfos < ActiveRecord::Migration
  def self.up
    create_table :work_flow_infos do |t|
      t.integer :doc_head_id
      t.integer :is_ok
      t.integer :people_id
      t.text :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :work_flow_infos
  end
end
