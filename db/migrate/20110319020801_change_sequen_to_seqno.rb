class ChangeSequenToSeqno < ActiveRecord::Migration
  def self.up
    add_column :fixed_properties,:seq_no,:string
    change_column :fixed_properties,:sequence,:integer
  end

  def self.down
  end
end
