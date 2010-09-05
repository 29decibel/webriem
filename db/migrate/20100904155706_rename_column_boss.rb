class RenameColumnBoss < ActiveRecord::Migration
  def self.up
    rename_column :people,:boss,:boss_id
  end

  def self.down
    rename_column :people,:boss_id,:boss
  end
end
