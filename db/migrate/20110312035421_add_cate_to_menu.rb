class AddCateToMenu < ActiveRecord::Migration
  def self.up
    add_column :menus,:first_category,:string
    add_column :menus,:second_category,:string
  end

  def self.down
  end
end
