class AddMenuTypeToMenu < ActiveRecord::Migration
  def self.up
    add_column :menus,:menu_type,:integer
  end

  def self.down
    remove_column :menus,:menu_type
  end
end
