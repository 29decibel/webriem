class RemovePairentMenu < ActiveRecord::Migration
  def self.up
    remove_column :menus,:menu_category_id
  end

  def self.down
  end
end
