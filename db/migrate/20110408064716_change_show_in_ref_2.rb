class ChangeShowInRef2 < ActiveRecord::Migration
  def self.up
    change_column :fees,:show_in_ref,:integer
  end

  def self.down
  end
end
