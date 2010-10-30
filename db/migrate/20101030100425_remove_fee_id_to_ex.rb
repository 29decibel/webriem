class RemoveFeeIdToEx < ActiveRecord::Migration
  def self.up
    remove_column :extra_work_standards,:extra_work_type_id
  end

  def self.down
  end
end
