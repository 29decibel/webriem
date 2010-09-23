class AddStateToDoc < ActiveRecord::Migration
  def self.up
    add_column :doc_heads,:doc_state,:integer
    add_column :doc_heads,:work_flow_step_id,:integer
  end

  def self.down
     remove_column :doc_heads,:doc_state
     remove_column :doc_heads,:work_flow_step_id
  end
end
