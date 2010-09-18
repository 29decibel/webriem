class AddColumnToReimDetail < ActiveRecord::Migration
  def self.up
    add_column :reim_details,:doc_head_id,:integer
  end

  def self.down
    remove_column :reim_details,:doc_head_id
  end
end
