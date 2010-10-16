class CreateMenuRights < ActiveRecord::Migration
  def self.up
    create_table :menu_rights do |t|
      t.integer :role_id
      t.integer :menu_id

      t.timestamps
    end
  end

  def self.down
    drop_table :menu_rights
  end
end
