class AddOtherInfoToVouch < ActiveRecord::Migration
  def self.up
    add_column :vouches,:item_id,:integer
    add_column :vouches,:code_id,:integer
    add_column :vouches,:code_equal_id,:integer
    add_column :vouches,:person_id,:integer
    add_column :u8codes,:year,:integer
  end

  def self.down
  end
end
