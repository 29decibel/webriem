class ChangeProjectColumnType < ActiveRecord::Migration
  def self.up
    change_column :projects,:status,:string
  end

  def self.down
  end
end
