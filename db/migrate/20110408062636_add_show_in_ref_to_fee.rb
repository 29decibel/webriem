class AddShowInRefToFee < ActiveRecord::Migration
  def self.up
    add_column :fees,:show_in_ref,:integer
  end

  def self.down
  end
end
