class CreateRiemCpOffsets < ActiveRecord::Migration
  def self.up
    create_table :riem_cp_offsets do |t|
      t.integer :reim_doc_head_id
      t.integer :cp_doc_head_id
      t.decimal :amount,:precision=>8,:scale=>2

      t.timestamps
    end
    #add one column for the cp doc_head
    add_column :doc_heads,:cp_doc_remain_amount,:decimal
  end

  def self.down
    drop_table :riem_cp_offsets
    remove_column :doc_heads,:cp_doc_remain_amount
  end
end
