class AddColumnToDep < ActiveRecord::Migration
  def self.up
    add_column :deps,:parent_dep_id,:integer
  end

  def self.down
    remove_column :deps,:parent_dep_id
  end
end
