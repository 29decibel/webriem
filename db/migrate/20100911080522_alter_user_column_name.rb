class AlterUserColumnName < ActiveRecord::Migration
  def self.up
    rename_column :users,:user_name,:name
  end

  def self.down
    rename_column :users,:user,:user_name
  end
end
