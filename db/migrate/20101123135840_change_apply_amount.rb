class ChangeApplyAmount < ActiveRecord::Migration
  def self.up
    rename_column :rd_benefits,:amount,:apply_amount
  end

  def self.down
  end
end
