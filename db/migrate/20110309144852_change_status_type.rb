class ChangeStatusType < ActiveRecord::Migration
  def self.up
    change_column :projects,:status,:integer
  end

  def self.down
  end
end
