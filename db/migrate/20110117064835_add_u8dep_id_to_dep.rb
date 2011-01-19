class AddU8depIdToDep < ActiveRecord::Migration
  def self.up
    add_column :deps,:u8_dep_id,:integer
  end

  def self.down
  end
end
