class RemovePaidCol < ActiveRecord::Migration
  def self.up
    remove_column :doc_heads,:paid
  end

  def self.down
  end
end
