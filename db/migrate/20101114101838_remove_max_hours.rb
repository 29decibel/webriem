class RemoveMaxHours < ActiveRecord::Migration
  def self.up
    remove_column :extra_work_standards,:larger_than_hours
    change_column :extra_work_standards,:late_than_time,:time
  end

  def self.down
  end
end
