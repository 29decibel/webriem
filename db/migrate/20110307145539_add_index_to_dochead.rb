class AddIndexToDochead < ActiveRecord::Migration
  def self.up
    add_index :doc_heads,:mark
    add_index :doc_heads,:doc_state
    add_index :doc_heads,:doc_type
    add_index :doc_heads,:work_flow_step_id
  end

  def self.down
  end
end
