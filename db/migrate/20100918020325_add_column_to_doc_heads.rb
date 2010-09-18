class AddColumnToDocHeads < ActiveRecord::Migration
  def self.up
    add_column :doc_heads,:doc_type,:integer
  end

  def self.down
    remove_column :doc_heads,:doc_type,:integer
  end
end
