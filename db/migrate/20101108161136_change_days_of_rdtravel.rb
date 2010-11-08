class ChangeDaysOfRdtravel < ActiveRecord::Migration
  def self.up
    change_column :rd_travels,:days,:decimal,:precision=>8,:scale=>2
  end

  def self.down
  end
end
