class RemoveBossFromPerson < ActiveRecord::Migration
  def self.up
    remove_column :people,:boss_id
  end

  def self.down
  end
end
