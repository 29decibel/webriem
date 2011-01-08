class AddApproversToDochead < ActiveRecord::Migration
  def self.up
    add_column :doc_heads,:approvers,:string
    rename_column :doc_heads,:approver_id,:selected_approver_id
  end

  def self.down
  end
end
