class ChangeDocHeadColumnType < ActiveRecord::Migration
  def self.up
    change_column :doc_heads,:doc_no,:string
  end

  def self.down
    change_column :doc_heads,:doc_no,:integer
  end
end
