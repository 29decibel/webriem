class AddColumnToExtra < ActiveRecord::Migration
  def self.up
    remove_column :extra_work_standards,:larger_than_hours
    add_column :extra_work_standards,:larger_than_hours,:decimal,:precision=>8,:scale=>2
  end

  def self.down
  end
end
