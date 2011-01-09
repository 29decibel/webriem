class ChangeApplydateToDate < ActiveRecord::Migration
  def self.up
    change_column :doc_heads,:apply_date,:date
  end

  def self.down
  end
end
