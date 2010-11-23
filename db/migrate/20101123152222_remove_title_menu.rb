class RemoveTitleMenu < ActiveRecord::Migration
  def self.up
    remove_column :menus,:title
    remove_column :menus,:name_en
  end

  def self.down
  end
end
