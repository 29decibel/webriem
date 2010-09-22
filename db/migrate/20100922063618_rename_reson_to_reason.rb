class RenameResonToReason < ActiveRecord::Migration
  def self.up
    rename_column :rd_travels,:reson,:reason
  end

  def self.down
    rename_column :rd_travels,:reason,:reson
  end
end
