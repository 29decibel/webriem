class AddEnNameToMenu < ActiveRecord::Migration
  def self.up
    add_column :menus,:name_en,:string
  end

  def self.down
  end
end
