class CreateMenuCategories < ActiveRecord::Migration
  def self.up
    create_table :menu_categories do |t|
      t.string :name
      t.text :description
      t.integer :parent_cate_id

      t.timestamps
    end
  end

  def self.down
    drop_table :menu_categories
  end
end
