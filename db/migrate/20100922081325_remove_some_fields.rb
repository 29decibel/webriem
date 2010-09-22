class RemoveSomeFields < ActiveRecord::Migration
  def self.up
    remove_column :rd_benefits,:dep_id
    remove_column :rd_benefits,:fee_id
  end

  def self.down
  end
end
