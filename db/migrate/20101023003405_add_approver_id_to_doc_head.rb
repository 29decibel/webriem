class AddApproverIdToDocHead < ActiveRecord::Migration
  def self.up
    add_column :doc_heads,:approver_id,:integer
  end

  def self.down
    add_column :doc_heads,:approver_id
  end
end
