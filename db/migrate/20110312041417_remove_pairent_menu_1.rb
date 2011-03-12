class RemovePairentMenu1 < ActiveRecord::Migration
  def self.up
    add_column :menus,:menu_category_id,:integer
    remove_column :menu_categories,:parent_cate_id
  end

  def self.down
  end
end
