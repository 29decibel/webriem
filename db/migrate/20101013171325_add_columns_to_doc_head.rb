class AddColumnsToDocHead < ActiveRecord::Migration
  def self.up
    add_column :doc_heads,:project_id,:integer
    add_column :doc_heads,:reim_description,:text
    add_column :doc_heads,:is_split,:integer
    add_column :doc_heads,:rate,:decimal,:precision => 8, :scale => 2
    add_column :doc_heads,:currency_id,:integer
    add_column :doc_heads,:apply_amount,:decimal,:precision => 8, :scale => 2
    add_column :doc_heads,:ori_amount,:decimal,:precision => 8, :scale => 2
    add_column :doc_heads,:real_amount,:decimal,:precision => 8, :scale => 2
  end

  def self.down
  end
end
