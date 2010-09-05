class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.string :code
      t.string :u8_project

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
