class ChangeColumnDocHeads < ActiveRecord::Migration
  def self.up
    change_column :doc_heads,:cp_doc_remain_amount,:decimal,:precision=>8,:scale=>2
  end

  def self.down
  end
end
