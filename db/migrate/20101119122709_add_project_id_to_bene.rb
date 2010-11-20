class AddProjectIdToBene < ActiveRecord::Migration
  def self.up
    add_column :rd_benefits,:project_id,:integer
  end

  def self.down
  end
end
