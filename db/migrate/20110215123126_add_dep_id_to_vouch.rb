class AddDepIdToVouch < ActiveRecord::Migration
  def self.up
    add_column :vouches,:dep_id,:integer
  end

  def self.down
  end
end
