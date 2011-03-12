class ChangeMenuCateType < ActiveRecord::Migration
  def self.up
    remove_column :menus,:first_category
    remove_column :menus,:second_category
    add_column :menus,:menu_category_id,:integer
  end

  def self.down
  end
end
