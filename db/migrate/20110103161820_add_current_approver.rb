class AddCurrentApprover < ActiveRecord::Migration
  def self.up
    add_column :doc_heads,:current_approver_id,:integer
  end

  def self.down
  end
end
