class AddTotalRiemToDoc < ActiveRecord::Migration
  def self.up
    add_column :doc_heads,:total_amount,:decimal,:precision=>8,:scale=>2
  end

  def self.down
  end
end
