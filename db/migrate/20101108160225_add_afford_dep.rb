class AddAffordDep < ActiveRecord::Migration
  def self.up
    add_column :doc_heads,:afford_dep_id,:integer
  end

  def self.down
  end
end
