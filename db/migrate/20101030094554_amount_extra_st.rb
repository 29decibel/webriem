class AmountExtraSt < ActiveRecord::Migration
  def self.up
    add_column :extra_work_standards,:amount,:decimal,:precision=>8,:scale=>2
  end

  def self.down
    remove_column :extra_work_standards,:amount
  end
end
