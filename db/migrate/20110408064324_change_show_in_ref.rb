class ChangeShowInRef < ActiveRecord::Migration
  def self.up
    change_column :fees,:show_in_ref,:string
  end

  def self.down
  end
end
