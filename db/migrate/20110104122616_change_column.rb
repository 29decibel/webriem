class ChangeColumn < ActiveRecord::Migration
  def self.up
    change_column :doc_heads,:apply_date,:datetime
  end

  def self.down
  end
end
