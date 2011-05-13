class AddStatusToDep < ActiveRecord::Migration
  def self.up
    add_column :deps,:status,:integer
  end

  def self.down
  end
end
