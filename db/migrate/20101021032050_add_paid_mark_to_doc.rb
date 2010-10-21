class AddPaidMarkToDoc < ActiveRecord::Migration
  def self.up
    add_column :doc_heads,:paid,:integer
  end

  def self.down
    remove_column :doc_heads,:paid
  end
end
