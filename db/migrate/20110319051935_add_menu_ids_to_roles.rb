class AddMenuIdsToRoles < ActiveRecord::Migration
  def self.up
    add_column :roles,:menu_ids,:string
  end

  def self.down
  end
end
