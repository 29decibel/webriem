class AddSpecfiyDepToVouch < ActiveRecord::Migration
  def self.up
    add_column :vouches,:s_cdept_id,:string
    add_column :vouches,:s_cperson_id,:string
  end

  def self.down
  end
end
